import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class PlayVideoComponent extends StatefulWidget {
  final String videoUrl;
  const PlayVideoComponent({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  State<PlayVideoComponent> createState() => _PlayVideoComponentState();
}

class _PlayVideoComponentState extends State<PlayVideoComponent> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);
    _controller.addListener(() {
      if (_controller.value.isInitialized) {
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: _controller.value.aspectRatio,
      height: screenSize.height - 320.h,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
