//make a custom full screen image widget class
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';

class CustomFullScreen extends StatelessWidget {
  final ImageProvider? image;
  final String? videoUrl;
  final String? tag;
  final double? height;
  final double? width;
  final Color? colorArrowBack;
  final bool? revert;
  const CustomFullScreen(
      {Key? key,this.videoUrl, this.image, this.tag, this.height, this.width,this.colorArrowBack, this.revert})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   automaticallyImplyLeading: true,
      //   ),
      backgroundColor: Colors.black87,
      body: Stack(
        children:[ 
          GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Transform.rotate(
               angle: revert!=null?(revert==true)?-90 * pi / 180:0:0,
              child: Hero(
                tag: tag??"1",
                child: Transform.rotate(
                  angle: revert!=null?(revert==true)?90 * pi / 180:0:0,
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: image!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
           AppBar(
              backgroundColor: CustomColor.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                color: colorArrowBack??CustomColor.primaryDarkAppColor,
              ),
            ),
        ]
      ),
    );
  }
}