import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class ThreeDimensionModellingPage extends StatefulWidget {
  const ThreeDimensionModellingPage({super.key});

  @override
  State<ThreeDimensionModellingPage> createState() => _ThreeDimensionModellingPageState();
}

class _ThreeDimensionModellingPageState extends State<ThreeDimensionModellingPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context,"back");
          },
        ),
        title: const Text('3D Modelling'),
      ),
      body:  UnityWidget(
                onUnityCreated: onUnityCreated,
                onUnityMessage: onUnityMessage,
                onUnitySceneLoaded: onUnitySceneLoaded,
                fullscreen: false,
              ),
    );

  }
      

  // Communication from Unity to Flutter
  void onUnityMessage(message) {
    debugPrint('Received message from unity: ${message.toString()}');
    //pop out from the page if receive the message from unity
    if(message.toString() == "message sent from unity"){
      Navigator.pop(context,"back");
    }
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    if (sceneInfo != null) {
      debugPrint('Received scene loaded from unity: ${sceneInfo.name}');
      debugPrint(
          'Received scene loaded from unity buildIndex: ${sceneInfo.buildIndex}');
    }
  }
}