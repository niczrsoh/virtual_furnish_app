
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
import 'package:flutter_cube/flutter_cube.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_loading_bar.dart';

class ARFlutterPage extends StatefulWidget {
  ARFlutterPage({super.key});

  @override
  State<ARFlutterPage> createState() => _ARFlutterPageState();
}

class _ARFlutterPageState extends State<ARFlutterPage> {
   ARSessionManager? arSessionManager;  
  ARObjectManager? arObjectManager;  
  ARAnchorManager? arAnchorManager;
  bool isModelDownloaded = false; 
    HttpClient? httpClient;
    File file = File('');
    String fileName = "vase clay.glb";
    List<ARNode> nodes = [];  
    List<ARAnchor> anchors = [];
    void initState() {
        _downloadFile(
        "https://firebasestorage.googleapis.com/v0/b/virtualfurnish-93c69.appspot.com/o/TestItems%2FVase_Clay.glb?alt=media&token=dc91c0f9-d1f1-45b3-90ac-4d9d9e0ff718",
        fileName);
    super.initState();
    }
    @override  
    void dispose() {    
    super.dispose();    
    arSessionManager!.dispose();  }
    @override  
    Widget build(BuildContext context) {    
    return Scaffold(        
      appBar: AppBar(          
        title: const Text('Anchors & Objects on Planes'),        
      ),        
      body: isModelDownloaded?Stack(children: [          
        ARView(        
          onARViewCreated: onARViewCreated,        
          planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,          
        ),      
      ]):RunningDotsLoader());}  
  

 void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showAnimatedGuide: false,
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: true,
          handleRotation: true,
          handlePans: true,
        );
    this.arObjectManager!.onInitialize();
    httpClient = new HttpClient();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    //this.arObjectManager!.onNodeTap = onNodeTapped;
  }
Future<File> _downloadFile(String url, String filename) async {
  try {
    // HttpClient.enableTimelineLogging = true;
    // SecurityContext securityContext = SecurityContext()
    //   ..setTrustedCertificatesBytes([]);
    // HttpClient httpClient = HttpClient(context: securityContext);
        HttpClient httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    print("converts the response body of an [HttpClientResponse] into a [Uint8List].");
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    //new directory
    // Create the 'waterTower' directory if it doesn't exist
    Directory waterTowerDir = Directory('$dir/vaseClay');
    await waterTowerDir.create(recursive: true);

    // Create the file in the 'waterTower' directory
    file = File('${waterTowerDir.path}/$filename');
    print("writing to file: " + '${file.path}');
    await file.writeAsBytes(bytes);
    print("Downloading finished, path: " + '$dir/$filename');
    setState(() {
      isModelDownloaded = true;
    });
    return file;
  } catch (e) {
    print('Error downloading file: $e');
    // Handle the error appropriately, e.g., show an error message, retry, etc.
    return File(''); // Return an empty file in case of an error
  }
}
 Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
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
          uri:  "vaseClay/$fileName", // duck.glb
          scale: Vector3(0.5, 0.5, 0.5),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );
      bool? didAddNodeToAnchor = await arObjectManager!
          .addNode(newNode, planeAnchor: newAnchor);
      if (didAddNodeToAnchor!) {
        nodes.add(newNode);
      } else {
        arSessionManager!.onError!("Adding Node to Anchor failed");
      }
    } else {
      arSessionManager!.onError!("Adding Anchor failed");
    }
  }
  Future<void> onRemoveEverything() async {
       for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    anchors = [];
  }
}