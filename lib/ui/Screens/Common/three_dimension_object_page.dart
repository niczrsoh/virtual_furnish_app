import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeDimensionObjectPage extends StatelessWidget {
  const ThreeDimensionObjectPage({super.key, required this.objectPath});
  final String objectPath;
  @override
  Widget build(BuildContext context) {
    print("object: "+objectPath);
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Object'),
      ),
      body: Center(
        child: ModelViewer(
         // src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
           src: objectPath,
          backgroundColor: Colors.white,
          ar: true,
          arModes: ['scene-viewer', 'webxr', 'quick-look'],
          autoRotate: true,
          iosSrc: objectPath,
         disableZoom: true,
        ),
      ),
    );
  }
}