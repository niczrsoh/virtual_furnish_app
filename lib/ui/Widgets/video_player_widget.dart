import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_loading_bar.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late bool _isPlaying;
  bool fetch = false;
  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.addListener(_videoListener);
        fetch = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return (fetch)? SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller),
          GestureDetector(
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                if (_isPlaying) {
                  _controller.play();
                } else {
                  _controller.pause();
                }
              });
            },
            child: AnimatedOpacity(
              opacity: _isPlaying ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ):RunningDotsLoader();
  }

  void _videoListener() {
    if (_controller.value.position == _controller.value.duration) {
      setState(() {
        _isPlaying = false;
        _controller.seekTo(Duration.zero);
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }
}
