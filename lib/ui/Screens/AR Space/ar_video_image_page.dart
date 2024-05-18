import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ARVideoImagesPage extends StatelessWidget {
  const ARVideoImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Video Images'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'AR Video Images',
            ),
          ],
        ),
      ),
    );
  }
}