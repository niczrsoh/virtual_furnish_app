import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';

class VideoPlayerScreen extends StatefulWidget {
  final File? videoFile;
  final String? uri;
  const VideoPlayerScreen({Key? key, this.videoFile, this.uri}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if(widget.uri!=null){
      _controller = VideoPlayerController.network(widget.uri!)
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
    }
    else{
      _controller = VideoPlayerController.file(widget.videoFile!)
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: CustomColor.transparent,
              leading: CircleAvatar(
                backgroundColor: CustomColor.primaryDarkAppColor.withOpacity(0.3),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: CustomColor.primaryBackgroundColor,
                ),
              ),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

