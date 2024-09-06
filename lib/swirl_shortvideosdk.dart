library swirl_shortvideosdk;

import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/screens/fullscreen_video.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem {
  final String url;
  VideoPlayerController controller;
  bool isMuted;

  VideoPlayerItem({
    required this.url,
    required this.controller,
    this.isMuted = true,
  });
}

class AutoplayVideoList extends StatefulWidget {
  const AutoplayVideoList({super.key});

  @override
  _AutoplayVideoListState createState() => _AutoplayVideoListState();
}

class _AutoplayVideoListState extends State<AutoplayVideoList> {
  late PageController _pageController;
  int _currentPage = 0;
  late List<VideoPlayerItem> _videos;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.5);

    // Initialize the list of VideoPlayerItems
    _videos = [
      VideoPlayerItem(
        url:
            'https://stream.mux.com/2oCDAFRZFn00Z00qPsCj8ix5QL2Wp85kGzhyNt6SnhFBM/high.mp4',
        controller: VideoPlayerController.network(
            'https://stream.mux.com/2oCDAFRZFn00Z00qPsCj8ix5QL2Wp85kGzhyNt6SnhFBM/high.mp4'),
      ),
      VideoPlayerItem(
        url:
            'https://stream.mux.com/6589Ol8pOfWqrOb2qVbATO02rPRP5aV6Lq65A02cKgR500/high.mp4',
        controller: VideoPlayerController.network(
            'https://stream.mux.com/6589Ol8pOfWqrOb2qVbATO02rPRP5aV6Lq65A02cKgR500/high.mp4'),
      ),
      VideoPlayerItem(
        url:
            'https://stream.mux.com/rmJdki7ppMmfxmRORCFdRO7Ragi9fa2rmpvzNPDr01ek/high.mp4',
        controller: VideoPlayerController.network(
            'https://stream.mux.com/rmJdki7ppMmfxmRORCFdRO7Ragi9fa2rmpvzNPDr01ek/high.mp4'),
      ),
      VideoPlayerItem(
        url:
            'https://stream.mux.com/2oCDAFRZFn00Z00qPsCj8ix5QL2Wp85kGzhyNt6SnhFBM/high.mp4',
        controller: VideoPlayerController.network(
            'https://stream.mux.com/2oCDAFRZFn00Z00qPsCj8ix5QL2Wp85kGzhyNt6SnhFBM/high.mp4'),
      ),
      VideoPlayerItem(
        url:
            'https://stream.mux.com/2oCDAFRZFn00Z00qPsCj8ix5QL2Wp85kGzhyNt6SnhFBM/high.mp4',
        controller: VideoPlayerController.network(
            'https://stream.mux.com/2oCDAFRZFn00Z00qPsCj8ix5QL2Wp85kGzhyNt6SnhFBM/high.mp4'),
      ),
    ];

    _initializeVideos();
  }

  void _initializeVideos() {
    for (var video in _videos) {
      video.controller.initialize().then((_) {
        // Initially, set the video to be muted
        video.controller.setVolume(0.0);
        setState(() {});
      });
    }
  }

  void _initializeVideosFullScreen() {
    for (var video in _videos) {
      video.controller.initialize().then((_) {
        // Initially, set the video to be muted
        video.controller.setVolume(1.0);
        setState(() {});
      });
    }
  }

  void _playVideo(int index) {
    for (int i = 0; i < _videos.length; i++) {
      if (i == index) {
        _videos[i].controller.play();
      } else {
        _videos[i].controller.pause();
      }
    }
  }

  void _toggleMute(int index) {
    setState(() {
      if (_videos[index].isMuted) {
        _videos[index].controller.setVolume(1.0); // Unmute
      } else {
        _videos[index].controller.setVolume(0.0); // Mute
      }
      _videos[index].isMuted = !_videos[index].isMuted;
    });
  }

  @override
  void dispose() {
    for (var video in _videos) {
      video.controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _playVideo(index);
              },
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        video.controller.setVolume(1.0);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FullScreenVideo(
                                videoController: video.controller),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: video.controller.value.isInitialized
                              ? video.controller.value.aspectRatio
                              : 16 / 9,
                          child: VideoPlayer(video.controller),
                        ),
                      ),
                    ),
                    // Mute/Unmute Button
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(
                          video.isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.black,
                        ),
                        onPressed: () => _toggleMute(index),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (_currentPage > 0) {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  if (_currentPage < _videos.length - 1) {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}







// class BoxImages extends StatefulWidget {
//   const BoxImages({super.key});

//   @override
//   State<BoxImages> createState() => _BoxImagesState();
// }

// class _BoxImagesState extends State<BoxImages> {
//   @override
//   Widget build(BuildContext context) {
//     return Text("Hello");
//   }
// }
