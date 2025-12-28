import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String path;

  const VideoPage({super.key, required this.path});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset(widget.path)
      ..initialize().then((_) {
        setState(() {});
        controller.play();
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
