import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';
import 'package:swirl_shortvideosdk/screens/fullscreen_video.dart';
import 'package:swirl_shortvideosdk/widgets/bottom_product_widget.dart';
import 'package:swirl_shortvideosdk/model/product.dart';
import 'package:swirl_shortvideosdk/model/videoData.dart';
import 'package:video_player/video_player.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoPlayerItem {
  final String url;
  VideoPlayerController controller;
  bool isMuted;
  final List<Product> products;

  VideoPlayerItem({
    required this.url,
    required this.controller,
    this.isMuted = true,
    required this.products,
  });
}

int calculateDiscountPercentage(int originalPrice, int discountPrice) {
  if (originalPrice <= 0 || discountPrice <= 0) return 0; // Handle edge cases
  double discountPercentage =
      ((originalPrice - discountPrice) / originalPrice) * 100;
  return discountPercentage.round(); // Return the rounded value as an integer
}

class AutoplayVideoList extends StatefulWidget {
  const AutoplayVideoList({super.key});

  @override
  _AutoplayVideoListState createState() => _AutoplayVideoListState();
}

class _AutoplayVideoListState extends State<AutoplayVideoList> {
  late PageController _pageController;
  int _currentPage = 0;
  List<VideoCoverImage> _videoCoverImages = [];
  List<VideoPlayerItem> _videos = []; // Initialize with an empty list
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();
  List<int> shownItemsIndexOnScreen = [];
  int startIndex = 0;
  int endIndex = 0;

  void getShownItemsIndex() {
    itemPositionsListener.itemPositions.addListener(() {
      shownItemsIndexOnScreen = itemPositionsListener.itemPositions.value
          .where((element) {
            final isPreviousVisible = element.itemLeadingEdge >= 0;
            // final isNextVisble = element.itemTrailingEdge <= 1;
            return isPreviousVisible;
          })
          .map((item) => item.index)
          .toList();

      startIndex = shownItemsIndexOnScreen.isEmpty
          ? 0
          : shownItemsIndexOnScreen.reduce(min);

      endIndex = shownItemsIndexOnScreen.isEmpty
          ? 0
          : shownItemsIndexOnScreen.reduce(max);
      // Trigger video playback for the current visible index
      if (_currentPage != startIndex) {
        _currentPage = startIndex;
        _playVideo(_currentPage);
      }
    });
  }

  void scrollToNext() async {
    if (shownItemsIndexOnScreen.isEmpty) {
      getShownItemsIndex();
    } else {
      if (endIndex < _videos.length - 1) {
        await itemScrollController.scrollTo(
            index: endIndex + 1,
            alignment: 0.8,
            duration: const Duration(milliseconds: 200));
        return;
      } else {}
    }
  }

  void scrollToPrevious() async {
    if (shownItemsIndexOnScreen.isEmpty) {
      getShownItemsIndex();
    } else {
      if (startIndex > 0) {
        await itemScrollController.scrollTo(
            index: startIndex - 1,
            alignment: 0,
            duration: const Duration(milliseconds: 200));

        return;
      } else {}
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.5);
    fetchVideoData(); // Fetch video data during initialization
  }

  Future<void> fetchVideoData() async {
    final url = Uri.parse(
        'https://pdp-reviews-api.goswirl.in/api/product/reviews/playlist?sCode=gzrfg86k&pCodes=&url=https://livevideoshopping.in/test/lg-pdp-ar.html&reviewId=1'); // Replace with your API URL
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final videoData = VideoData.fromJson(json.decode(response.body));
        setState(() {
          _videos = videoData.swirls.videos.map((video) {
            return VideoPlayerItem(
                url: video.videoUrl,
                controller: VideoPlayerController.network(video.videoUrl),
                products: video.products);
          }).toList();
        });
        setState(() {
          _videoCoverImages = videoData.swirls.videos.map((video) {
            return VideoCoverImage(
              coverurl: video.coverImage,
            );
          }).toList();
        });

        print('data $_videoCoverImages');
        _initializeVideos(); // Initialize video controllers after data is fetched
      } else {
        throw Exception('Failed to load video data');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
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

  // void _playVideo(int index) {
  //   for (int i = 0; i < _videos.length; i++) {
  //     if (i == index) {
  //       _videos[i].controller.play();
  //     } else {
  //       _videos[i].controller.pause();
  //     }
  //   }
  // }
  void _playVideo(int index) {
    // Stop any other videos that are currently playing
    for (int i = 0; i < _videos.length; i++) {
      if (i == index) {
        if (!_videos[i].controller.value.isPlaying) {
          _videos[i].controller.play();
        }

        // Add listener for video completion
        _videos[i].controller.addListener(() {
          if (_videos[i].controller.value.position ==
              _videos[i].controller.value.duration) {
            // Video has finished, reset to the beginning
            _videos[i].controller.seekTo(Duration.zero);
          }
        });
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
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 0, left: 4.0, right: 4.0, top: 50),
          child: SizedBox(
            height: 300.0,
            child: Stack(
              children: [
                ScrollablePositionedList.separated(
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemCount: _videos.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    if (index == _currentPage) {
                      _playVideo(index);
                    }
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            video.controller.setVolume(1.0);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FullScreenVideoPlayer(
                                  videoUrls: _videos
                                      .map((video) => video.url)
                                      .toList(),
                                  initialIndex:
                                      index, // Start playing the tapped video
                                  products: video.products,
                                  // images: _videoCoverImages
                                  //     .map((video) => video.coverurl)
                                  //     .toList()
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(children: [
                                Container(
                                    width: 162,
                                    height: 276,
                                    child: VideoPlayer(video.controller)),

                                // AspectRatio(
                                //   aspectRatio:
                                //       video.controller.value.isInitialized
                                //           ? video.controller.value.aspectRatio
                                //           : 16 / 9,
                                //   child: VideoPlayer(video.controller),
                                // ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 26.0,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(
                                              0xFF000000), // Full black at the top
                                          Color(
                                              0x382A2929), // Semi-transparent (#2A292938)
                                          Color(0x002A2929),
                                        ],
                                        stops: [0.0, 0.22, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: ClipPath(
                                    clipper: CustomCurvedClipper(),
                                    child: Container(
                                      width: 80, // Fixed width
                                      height: 22,
                                      color: AppColor.hotDealBackgroundColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4), // Reduce padding here
                                      child: Row(children: [
                                        const SizedBox(width: 2),
                                        Image.asset(
                                          'packages/swirl_shortvideosdk/assets/images/emoji_fire.png',
                                          width: 12,
                                          height: 12,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          'Hot Deals',
                                          style: TextStyle(
                                            color: AppColor.hotDealColor,
                                            fontSize: 12,
                                            fontFamily: 'CircularStd',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Row(children: [
                                        Image.asset(
                                          'packages/swirl_shortvideosdk/assets/images/eye.png',
                                          width: 12,
                                          height: 12,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '34',
                                          style: TextStyle(
                                            color: AppColor
                                                .pricePercentageTextColor,
                                            fontSize: 12,
                                            fontFamily: 'CircularStd',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),

                                // Bottom Gradient
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 56.0,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(
                                              0x002A2929), // Transparent (#2A292900)
                                          Color(
                                              0x382A2929), // Semi-transparent (#2A292938)
                                          Color(
                                              0xFF000000), // Opaque black (#000000)
                                          // Colors.black.withOpacity(0.8),
                                          // Colors.transparent,
                                        ],
                                        stops: [
                                          0.0,
                                          0.22,
                                          1.0
                                        ], // 0%, 22%, and 100% stops
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    //child: BottomProductWidget()
                                    child: BottomProductWidget(
                                      product: video.products
                                          .first, // Pass the first product
                                    )),
                              ]),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 4.0,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircularIndicatorButton(
                    isLeft: true,
                    onTap: () {
                      scrollToPrevious();
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CircularIndicatorButton(
                    isLeft: false,
                    onTap: () {
                      scrollToNext();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircularIndicatorButton extends StatelessWidget {
  const CircularIndicatorButton({Key? key, required this.isLeft, this.onTap})
      : super(key: key);

  final bool isLeft;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color.fromARGB(128, 46, 46, 51),
          ),
          child: Center(
            child: Icon(
              isLeft ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
      );
}

class CustomCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at the top-left corner
    path.moveTo(0, 0);

    // Draw a straight line to the top-right corner
    path.lineTo(size.width, 0);

    // Move to the bottom-right corner and create a smoother curve
    path.lineTo(
        size.width, size.height * 0.65); // Adjust the depth of the curve
    path.quadraticBezierTo(
      size.width, // Control point x
      size.height, // Control point y for curve depth
      size.width * 0.85, // Adjust this value to move curve left or right
      size.height, // End point y: aligned with the bottom edge
    );

    // Draw a straight line to the bottom-left corner
    path.lineTo(0, size.height);

    // Close the path to form the curve
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
