import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatelessWidget {
  final VideoPlayerController videoController;

  const FullScreenVideo({super.key, required this.videoController});

  @override
  Widget build(BuildContext context) {
    videoController.setVolume(1.0);

    return WillPopScope(
      onWillPop: () async {
        // Mute the video when back button is pressed
        videoController.setVolume(0.0);
        return true; // Allow the pop
      },
      child: Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: videoController.value.isInitialized
                ? videoController.value.aspectRatio
                : 16 / 9,
            child: VideoPlayer(videoController),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            videoController.value.isPlaying
                ? videoController.pause()
                : videoController.play();
          },
          child: Icon(
            videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}
