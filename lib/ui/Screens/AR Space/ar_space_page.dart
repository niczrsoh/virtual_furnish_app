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
import 'package:dartz/dartz_unsafe.dart';
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
  String? fileType;
  String? initItemID;
  String? initFilename;
  String? initFileType;
  String? initCategory;
  HttpClient? httpClient;
  String? category;
  bool isItemPlaced = false;
  bool isMultipleItemsPlaced = false;
  File file = File('');
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  Map<ARNode, ARAnchor> nodeAnchorMap = {};
  bool isPlaneDetected = false;
  bool canPlaceItem = false;
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
        endDrawer: Drawer(
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
        appBar: AppBar(
          title: Text('AR Space'),
          centerTitle: true,
        ),
        body: BlocConsumer<ArControllerBloc, ArControllerState>(
            listenWhen: (previous, current) =>
                current is ArControllerSuccessDownloadSubsequentModel,
            buildWhen: (previous, current) =>
                current is! ArControllerActionState,
            listener: (context, state) {
              // TODO: implement listener
              if (state is ArControllerLoadingSubsequentModels) {
                CustomSnackbar.showLoadingSnackbar(
                    context, "Preparing the model. Please wait...");
              }
              if (state is ArControllerSuccessDownloadSubsequentModel) {
                CustomSnackbar.showLoadingSnackbar(
                    context, "Setting up the model. Please wait...");
                if (isMultipleItemsPlaced == false) {
                  isMultipleItemsPlaced = true;
                }
                itemId = state.itemID;
                filename = state.filename;
                category = state.category;
                CustomSnackbar.showSuccessSnackbar(context,
                    "Model prepared successfully. You can now place the item above the white dots in the scene.");
               canPlaceItem = true;
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
                  fileType = currentState.fileType;
                  category = currentState.category;
                  initItemID = itemId;
                  initFilename = filename;
                  initFileType = fileType;
                  initCategory = category;
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
                          child: Column(
                            children: [
                              IconButton(
                                icon:
                                    Icon(Icons.camera_alt, color: Colors.white),
                                onPressed: onTakingScreenshot,
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: onDeleteObject,
                                      icon: Icon(Icons.delete,
                                          color: Colors.white)),
                                  IconButton(
                                    icon: const Icon(Icons.manage_search,
                                        color: Colors.white),
                                    onPressed: onManageSearch,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.refresh,
                                        color: Colors.white),
                                    onPressed: onRefreshScene,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ]);
                case ArControllerLoading:
                  return Container(
                    child: Center(child: RunningDotsLoader()),
                  );
                case ArControllerFailedDownloadModel:
                  return Container(
                    child: Center(
                      child: Text('Failed to download the model'),
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
          handleTaps: true,
        );
    this.arObjectManager!.onInitialize();
    httpClient = new HttpClient();
    //before plane detected, do not allow the user to place the item in the scene

    this.arSessionManager!.onError = (String error) {
      CustomSnackbar.showFailSnackbar(context, error);
    };
    //disallow user to place the item in the scene until plane detected

    CustomSnackbar.showLoadingSnackbar(
        context, "Detecting planes. Please wait until plane detected.");
    this.arSessionManager!.onPlaneDetected = (planeCount) {
      //after few seconds, show a snackbar to inform the user that a plane has been detected
      if (isPlaneDetected == false) {
        Timer(Duration(seconds: 2), () {
          if (planeCount == 0) {
            CustomSnackbar.showFailSnackbar(
                context, "No plane detected. Please try again.");
          } else {
            setState(() {
              isPlaneDetected = true;
              canPlaceItem = true;
            });
            CustomSnackbar.showSuccessSnackbar(context,
                "Plane detected. You can now place the item above the white dots in the scene.");
            this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
          }
        });
      }
      //if plane detected or point tapped, then only can place the item in the scene
    };
    //this.arObjectManager!.onNodeTap = onNodeTapped;
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    if (canPlaceItem == false) {
      AlertDialog(
        title: Text("Alert"),
        content: Text("Sorry for the late. Please wait a moment."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      );
      return;
    }
    //if the hit result is a node
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
        var newNode;
        print("filetype: $fileType");
        if (fileType == "glb") {
          newNode = ARNode(
            type: NodeType.fileSystemAppFolderGLB,
            // type: NodeType.localGLTF2,
            uri: "${itemId}/$filename", // duck.glb
            scale: Vector3(0.5, 0.5, 0.5),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0),
          );
        } else if (fileType == "gltf") {
          newNode = ARNode(
            type: NodeType.fileSystemAppFolderGLTF2,
            // type: NodeType.localGLTF2,
            uri: "${itemId}/$filename", // duck.gltf
            scale: Vector3(0.5, 0.5, 0.5),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0),
          );
        }
        bool? didAddNodeToAnchor =
            await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          nodes.add(newNode);
          nodeAnchorMap[newNode] = newAnchor;
          isItemPlaced = true;
        } else {
          arSessionManager!.onError!("Adding Node to Anchor failed");
        }
      } else {
        arSessionManager!.onError!("Adding Anchor failed");
      }
      //if ar object tap will have respond
    } else {
      //pop up a dialog to inform the user that only one item can be placed at a time
      CustomSnackbar.showFailSnackbar(
          context, "The item is already placed in the scene.");
    }
  }

  void onTakingScreenshot() async {
    //detect if there is any object in the scene
    if (isItemPlaced == false) {
      CustomSnackbar.showFailSnackbar(
          context, "No object in the scene to take a screenshot.");
      return;
    }
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
    //set back to the initial model
    setState(() {
      itemId = initItemID;
      filename = initFilename;
      fileType = initFileType;
      category = initCategory;
    });
    isItemPlaced = false;
    anchors = [];
  }

  void onDeleteObject() async {
    CustomSnackbar.showNormalSnackbar(context, "Select an object to delete.");
    arObjectManager!.onNodeTap = (node) async {
      ARNode? nodeToDelete =
          nodes.firstWhere((element) => element.name == node.first);
      ARAnchor? anchorToDelete;
      //loop nodeAchorMap
      for (var key in nodeAnchorMap.keys) {
        if (key == nodeToDelete) {
          anchorToDelete = nodeAnchorMap[key];
          await arAnchorManager!.removeAnchor(anchorToDelete!);
          break;
        }
      }
      await this.arObjectManager!.removeNode(nodeToDelete);
      nodes.remove(nodeToDelete);
      anchors.remove(anchorToDelete);
      nodeAnchorMap.remove({nodeToDelete: anchorToDelete});
      //do not handle on node tap
      arObjectManager!.onNodeTap = null;
      CustomSnackbar.showSuccessSnackbar(
          context, "Object ${node.first} deleted successfully.");
    };
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
                              setState(() {
                                canPlaceItem = false;
                              });
                              CustomSnackbar.showLoadingSnackbar(context,
                                  "Preparing the model. Please wait...");
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
