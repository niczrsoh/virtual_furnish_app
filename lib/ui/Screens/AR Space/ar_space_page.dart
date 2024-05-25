import 'dart:async';
import 'dart:io';
import 'package:ar_flutter_plugin_flutterflow/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:ar_flutter_plugin_flutterflow/widgets/ar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';
import 'package:virtual_furnish_app/bloc/ARSpace/ar_controller_bloc.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_loading_bar.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';

class ARSpacePage extends StatefulWidget {
  const ARSpacePage({super.key, required this.arControllerBloc});
  final ArControllerBloc arControllerBloc;
  @override
  State<ARSpacePage> createState() => _ARSpacePageState();
}

class _ARSpacePageState extends State<ARSpacePage> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  String? itemId;
  String? filename;
  HttpClient? httpClient;
  String? category;
  bool isItemPlaced = false;
  bool isMultipleItemsPlaced = false;
  File file = File('');
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  bool isPlaneDetected = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    // TODO: implement dispose
    arSessionManager!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:   Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    ListTile(
                      title: CheckboxListTile(
                        title: Text('Show multiple items ?'),
                        value: isMultipleItemsPlaced,
                        onChanged: (bool? value) {
                          setState(() {
                            isMultipleItemsPlaced = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
        appBar: AppBar(title: Text('AR Space'), centerTitle: true, 
        ),
        body: BlocConsumer<ArControllerBloc, ArControllerState>(
          listenWhen: (previous, current) => current is ArControllerSuccessDownloadSubsequentModel,
            buildWhen: (previous, current) => current is! ArControllerActionState && current is! ArControllerSuccessDownloadSubsequentModel,
            listener: (context, state) {
              // TODO: implement listener
              if (state is ArControllerSuccessDownloadSubsequentModel) {
                itemId = state.itemID;
                filename = state.filename;
                category = state.category;
                 setState(() {
                            isMultipleItemsPlaced = true;
                          });
                this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
              }
            },
            builder: (context, state) {
              switch (state.runtimeType) {
                case ArControllerInitial:
                  return Container(
                    child: Center(
                      child: RunningDotsLoader(),
                    ),
                  );
                case ArControllerSuccessDownloadModel:
                  var currentState = state as ArControllerSuccessDownloadModel;
                  itemId = currentState.itemID;
                  filename = currentState.filename;
                  category = currentState.category;
                  return Stack(children: [
                    ARView(
                      onARViewCreated: onARViewCreated,
                      planeDetectionConfig:
                          PlaneDetectionConfig.horizontalAndVertical,
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.manage_search,
                                    color: Colors.white),
                                onPressed: onManageSearch,
                              ),
                              IconButton(
                                icon:
                                    Icon(Icons.camera_alt, color: Colors.white),
                                onPressed: onTakingScreenshot,
                              ),
                              IconButton(
                                icon: Icon(Icons.refresh, color: Colors.white),
                                onPressed: onRefreshScene,
                              ),
                            ],
                          ),
                        )),
                  ]);
                case ArControllerFailedDownloadModel:
                  return Container(
                    child: Center(
                      child: Text('Failed to download the model'),
                    ),
                  );
                case ArControllerLoading:
                  return Container(
                    child: Center(child: RunningDotsLoader()),
                  );
                default:
                  return Container(
                    child: Center(
                      child:
                          Text('Something went wrong. Please try again later.'),
                    ),
                  );
              }
            }));
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;
    this.arSessionManager!.onInitialize(
          showAnimatedGuide: false,
          showFeaturePoints: true,
          showPlanes: true,
          showWorldOrigin: false,
          handleRotation: true,
          handlePans: true,
        );
    this.arObjectManager!.onInitialize();
    httpClient = new HttpClient();
    //before plane detected, do not allow the user to place the item in the scene
   
    this.arSessionManager!.onError = (String error) {
      CustomSnackbar.showFailSnackbar(context, error);
    };
    CustomSnackbar.showLoadingSnackbar(
        context, "Detecting planes. Please wait until plane detected.");
    this.arSessionManager!.onPlaneDetected = (planeCount) {
      //after few seconds, show a snackbar to inform the user that a plane has been detected
      if (isPlaneDetected == false) {
        Timer(Duration(seconds: 5), () {
          if (planeCount == 0) {
            CustomSnackbar.showFailSnackbar(
                context, "No plane detected. Please try again.");
          } else {
            isPlaneDetected = true;
            CustomSnackbar.showSuccessSnackbar(context,
                "Plane detected. You can now place the item above the white dots in the scene.");
          }
        });
      }
   
      //if plane detected or point tapped, then only can place the item in the scene
      this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    };
    //this.arObjectManager!.onNodeTap = onNodeTapped;
  }
 
  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    CustomSnackbar.showLoadingSnackbar(
        context, "Placing the item above the white dots. Please wait...");
    if (!isItemPlaced || isMultipleItemsPlaced) {
      var singleHitTestResult = hitTestResults.firstWhere(
          (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
          type: NodeType.fileSystemAppFolderGLB,
          // type: NodeType.localGLTF2,
          uri: "${itemId}/$filename", // duck.glb
          scale: Vector3(0.5, 0.5, 0.5),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0),
        );
        bool? didAddNodeToAnchor =
            await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          nodes.add(newNode);
          isItemPlaced = true;
        } else {
          arSessionManager!.onError!("Adding Node to Anchor failed");
        }
      } else {
        arSessionManager!.onError!("Adding Anchor failed");
      }
    } else {
      //pop up a dialog to inform the user that only one item can be placed at a time
      CustomSnackbar.showFailSnackbar(
          context, "The item is already placed in the scene.");
    }
  }

  void onTakingScreenshot() async {
    //remove the plane detection and feature points
    arSessionManager!.onInitialize(
      showAnimatedGuide: false,
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
      handleRotation: false,
      handlePans: false,
    );
    ImageProvider image = await arSessionManager!.snapshot();
    //dispose
    arSessionManager!.dispose();
    // Open the image in another screen
    var message = await Navigator.pushNamed(context, '/ar_screenshot',
        arguments: {'image': image});
    if (message == "back") {
      //reinitialize the AR session
      widget.arControllerBloc.add(ArControllerLoad(itemId: itemId!));
    }
  }

  void onRefreshScene() async {
    CustomSnackbar.showLoadingSnackbar(
        context, "Refreshing the scene. Please wait...");
    for (var anchor in anchors) {
      await arAnchorManager!.removeAnchor(anchor);
    }
    isItemPlaced = false;
    anchors = [];
  }

  void onManageSearch() {
    widget.arControllerBloc
        .add(ArControllerAnalyseObject(category: category ?? "CHAIR"));
    //pop up a bottom sheet to allow the user to search for another item
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BlocConsumer<ArControllerBloc, ArControllerState>(
            bloc: widget.arControllerBloc,
            listener: (context, state) {},
            buildWhen: (previous, current) =>
                current is ArControllerActionState,
            builder: (context, state) {
              switch (state.runtimeType) {
                case ArControllerActionLoading:
                  return Container(
                    child: Center(
                      child: RunningDotsLoader(),
                    ),
                  );
                case ArControllerSuccessFetchedProducts:
                  var currentState =
                      state as ArControllerSuccessFetchedProducts;
                  return Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(
                            currentState.suggestedProduct.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              widget.arControllerBloc.add(
                                  ArControllerLoadSubsequentModels(
                                      itemId: currentState
                                          .suggestedProduct[index].id!));
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 60,
                                    width: mq.width * 0.4,
                                    child: Center(
                                      child: Image(
                                        image: Image.network(state
                                                .suggestedProduct[index]
                                                .images![0])
                                            .image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(state.suggestedProduct[index].name!),
                                ],
                              ),
                            ),
                          );
                        })),
                  );
                case ArControllerFailureFetchedProducts:
                  return Container(
                    child: Center(
                      child: Text('Failed to fetch the products'),
                    ),
                  );
                default:
                  return Container(
                    child: Center(
                      child:
                          Text('Something went wrong. Please try again later.'),
                    ),
                  );
              }
            },
          );
        });
  }
}
