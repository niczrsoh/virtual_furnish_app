import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeDimensionObjectPage extends StatefulWidget {
   ThreeDimensionObjectPage({super.key,this.objectPath});
  //final String objectPath; 
  //get firebase stoarge 3d model
  String? objectPath;

  @override
  State<ThreeDimensionObjectPage> createState() => _ThreeDimensionObjectPageState();
}

class _ThreeDimensionObjectPageState extends State<ThreeDimensionObjectPage> {
  @override
  Widget build(BuildContext context) {
   // objectPath = 'https://firebasestorage.googleapis.com/v0/b/virtualfurnish-93c69.appspot.com/o/TestItems%2Fbench.gltf?alt=media&token=c600eae1-feb2-4a7b-8f96-e97338d8f263';
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Object'),
      ),
      body: Center(
        child: ModelViewer(
          backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
          src: "https://firebasestorage.googleapis.com/v0/b/virtualfurnish-93c69.appspot.com/o/TestItems%2FSmiling%20Face.glb?alt=media&token=c5e122fc-66d3-4cda-a223-0d63fd358ecd",
          alt: 'A 3D model of an astronaut',
          ar: true,
          arModes: ['scene-viewer', 'webxr', 'quick-look'],
          autoRotate: true,
          iosSrc: 'https://firebasestorage.googleapis.com/v0/b/virtualfurnish-93c69.appspot.com/o/TestItems%2FSmiling%20Face.glb?alt=media&token=c5e122fc-66d3-4cda-a223-0d63fd358ecd',
          disableZoom: true,
        ),
      ),
    );
  }
}