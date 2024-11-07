import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';
import 'package:swirl_shortvideosdk/model/product.dart';
import 'package:swirl_shortvideosdk/model/videoData.dart';
import 'package:swirl_shortvideosdk/screens/chatlist.dart';
import 'package:swirl_shortvideosdk/screens/circleImagelistview.dart';
import 'package:swirl_shortvideosdk/screens/product_list_review_screen.dart';
import 'package:swirl_shortvideosdk/screens/product_list_with_Indicator.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'dart:convert'; // for json decoding
import 'package:http/http.dart' as http; // for making API requests
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class VideoCoverImage {
  final String coverurl;

  VideoCoverImage({
    required this.coverurl,
  });
}

class FullScreenVideoPlayer extends StatefulWidget {
  final List<String> videoUrls;
  final int initialIndex;
  final List<Product> products; // Add the products parameter

  const FullScreenVideoPlayer({
    required this.videoUrls,
    required this.initialIndex,
    required this.products, // Initialize the products list
  });

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late PageController _pageController;
  VideoPlayerController? _controller;
  int _currentIndex = 0;

  // State lists to track play and mute status for each video
  List<bool> _isPlayingList = [];
  List<bool> _isMutedList = [];
  bool _showControls = true;
  Timer? _hideTimer;
  bool _isExpanded = false;
  Timer? _collapseTimer; // Timer to handle collapsing of CircleImageListView
  bool _isCircleViewExpanded = false;
  List<VideoCoverImage> _videoCoverImages = [];
  bool isLoading = true; // Flag to indicate loading state
  List<Map<String, String>> _currentProducts = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // Initialize play and mute states for each video
    _isPlayingList = List<bool>.filled(widget.videoUrls.length, true);
    _isMutedList = List<bool>.filled(widget.videoUrls.length, false);

    _initializeAndPlay(_currentIndex);
    _startHideTimer(); // Start the timer initially
    fetchVideoCoverImages(); // Fetch video cover images when widget is initialized
  }

  Future<void> fetchVideoCoverImages() async {
    final url = Uri.parse(
        'https://pdp-reviews-api.goswirl.in/api/product/reviews/playlist?sCode=gzrfg86k&pCodes=&url=https://livevideoshopping.in/test/lg-pdp-ar.html&reviewId=1'); // Replace with your API URL
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final videoData = VideoData.fromJson(json.decode(response.body));

        setState(() {
          _videoCoverImages = videoData.swirls.videos.map((video) {
            return VideoCoverImage(
              coverurl: video.coverImage,
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load video data');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pageController.dispose();
    _hideTimer?.cancel();
    _collapseTimer?.cancel(); // Cancel the collapse timer
    super.dispose();
  }

  Future<void> downloadVideo(String videoUrl) async {
    try {
      // Get the directory for storing the video
      final directory = await getApplicationDocumentsDirectory();
      String savePath = "${directory.path}/downloaded_video.mp4";

      // Use Dio to download the file
      Dio dio = Dio();
      await dio.download(videoUrl, savePath);

      print("Video downloaded to: $savePath");
      // Optionally, show a message or open the file here
    } catch (e) {
      print("Download failed: $e");
    }
  }

  Future<void> _initializeAndPlay(int index) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = VideoPlayerController.network(widget.videoUrls[index])
      ..initialize().then((_) {
        setState(() {
          if (_isPlayingList[index]) {
            _controller?.play();
          } else {
            _controller?.pause();
          }
          _controller
              ?.setLooping(false); // Disable looping if you want manual replay
        });

        // Add listener to check when video ends
        _controller?.addListener(() {
          if (_controller!.value.position == _controller!.value.duration) {
            // Video finished, seek to the start to replay
            _controller?.seekTo(Duration.zero);
            _controller?.play(); // Optionally, play again
          }
        });
      });
    _expandCircleView(); // Expand CircleImageListView when video changes
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _initializeAndPlay(index);
      //    _isExpanded = true; // Expand the CircleImageListView when video jumps
    });
    _resetHideTimer(); // Reset timer when page changes
  }

  void _expandCircleView() {
    setState(() {
      _isCircleViewExpanded = true;
    });
    _startCollapseTimer(); // Start the collapse timer
  }

  void _startCollapseTimer() {
    _collapseTimer?.cancel(); // Cancel any existing timer
    _collapseTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _isCircleViewExpanded = false; // Collapse after 3 seconds
      });
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller != null) {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
          _isPlayingList[_currentIndex] = false;
        } else {
          _controller!.play();
          _isPlayingList[_currentIndex] = true;
        }
        _resetHideTimer(); // Reset timer when play/pause is toggled
      }
    });
  }

  void _toggleMuteUnmute() {
    setState(() {
      if (_controller != null) {
        _isMutedList[_currentIndex] = !_isMutedList[_currentIndex];
        _controller!.setVolume(_isMutedList[_currentIndex] ? 0.0 : 1.0);
        _resetHideTimer(); // Reset timer when mute/unmute is toggled
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        _showControls = false; // Hide controls after 3 seconds
      });
    });
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _showControls = true; // Show controls when resetting the timer
    _startHideTimer(); // Start a new timer
  }

  void _jumpToVideo(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
        _pageController.jumpToPage(index); // Jump to the selected video page
        _initializeAndPlay(index);
      });
    }
  }

  void _openReviewOverlay(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(16)), // Add curves to the top of the modal
      ),
      builder: (
        BuildContext context,
      ) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // State variable to track expansion
            return SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16)), // Add curves to the top
                ),
                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Center(
                      child: Image.asset(
                        'packages/swirl_shortvideosdk/assets/images/indicator.png',
                        width: 32,
                        height: 4,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ProductListReviewScreen(products: widget.products),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openChatOverlay(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16), // Add curves to the top of the modal
        ),
      ),
      isScrollControlled:
          true, // To adjust the modal height according to content
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.only(right: 15.0, left: 15.0),
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16), // Add curves to the top
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  // Drag indicator
                  Center(
                    child: Image.asset(
                      'packages/swirl_shortvideosdk/assets/images/indicator.png',
                      width: 32,
                      height: 4,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Comments title
                  const Center(
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        color: AppColor.productDetailTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Chat list with fixed height
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300, // Set the maximum height for chat list
                    ),
                    child: ChatList(),
                  ),
                  // Send comment layout
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        // Text input for comment
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Type a comment...",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: Image.asset(
                                'packages/swirl_shortvideosdk/assets/images/icon_chat.png',
                                width: 32,
                                height: 4,
                                color: AppColor.pricetTextColor,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Send button
                        IconButton(
                          onPressed: () {
                            // Add your send comment action here
                          },
                          icon: const Icon(Icons.send,
                              color: AppColor.pricetTextColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openVerticalOverlay(BuildContext context, int index, String videoUrl) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16), // Add curves to the top of the modal
        ),
      ),
      isScrollControlled:
          true, // To adjust the modal height according to content
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16), // Add curves to the top
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  // Drag indicator
                  Center(
                    child: Image.asset(
                      'packages/swirl_shortvideosdk/assets/images/indicator.png',
                      width: 32,
                      height: 4,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Comments title
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 5.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'packages/swirl_shortvideosdk/assets/images/pictureinpicture.png',
                          width: 18,
                          height: 18,
                          color: AppColor.pricetTextColor,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Picture in picture',
                          style: TextStyle(
                            color: AppColor.productDetailTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 10, color: AppColor.dividerColor),
                  InkWell(
                    onTap: () {
                      downloadVideo(
                          videoUrl); // Pass the dynamic video URL here
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0, bottom: 20.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'packages/swirl_shortvideosdk/assets/images/download.png',
                            width: 18,
                            height: 18,
                            color: AppColor.pricetTextColor,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Download video',
                            style: TextStyle(
                              color: AppColor.productDetailTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Evenly spaces icons horizontally
                        children: [
                          // Icon and label for Copy Link
                          Column(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor
                                      .pricePercentageTextColor, // Background color
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'packages/swirl_shortvideosdk/assets/images/copy_link.png',
                                    color: AppColor.pricetTextColor,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height: 4), // Space between icon and label
                              const Text(
                                'Copy link',
                                style: TextStyle(
                                  color: AppColor.sharetextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // Icon and label for WhatsApp
                          Column(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor
                                      .pricePercentageTextColor, // Background color
                                ),
                                child: InkWell(
                                  onTap: () {
                                    //  shareOnWhatsApp(context, videoUrl);
                                    print("send url $videoUrl");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'packages/swirl_shortvideosdk/assets/images/whatsapp.png',
                                      color: AppColor.pricetTextColor,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'WhatsApp',
                                style: TextStyle(
                                  color: AppColor.sharetextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // Icon and label for Facebook
                          Column(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor
                                      .pricePercentageTextColor, // Background color
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'packages/swirl_shortvideosdk/assets/images/facebook.png',
                                    color: AppColor.pricetTextColor,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Facebook',
                                style: TextStyle(
                                  color: AppColor.sharetextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor
                                      .pricePercentageTextColor, // Background color
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'packages/swirl_shortvideosdk/assets/images/twitter.png',
                                    color: AppColor.pricetTextColor,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'X',
                                style: TextStyle(
                                  color: AppColor.sharetextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // Icon and label for Mail
                          Column(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor
                                      .pricePercentageTextColor, // Background color
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'packages/swirl_shortvideosdk/assets/images/mail.png',
                                    color: AppColor.pricetTextColor,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Mail',
                                style: TextStyle(
                                  color: AppColor.sharetextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // Icon and label for SMS
                          Column(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor
                                      .pricePercentageTextColor, // Background color
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'packages/swirl_shortvideosdk/assets/images/sms.png',
                                    color: AppColor.pricetTextColor,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'SMS',
                                style: TextStyle(
                                  color: AppColor.sharetextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
            if (_showControls) {
              _resetHideTimer();
            }
          });
        },
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: widget.videoUrls.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                _controller != null && _controller!.value.isInitialized
                    ? SizedBox(
                        width: screenSize.width,
                        height: screenSize.height,
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
                // Top Gradient
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 52,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(
                              23, 21, 21, 0.0), // #171515 at 0% opacity
                          Color.fromRGBO(
                              23, 21, 21, 0.4), // #171515 at 40% opacity
                          Color(0xFF312C2C),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Bottom Gradient
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 154,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(6, 5, 5, 0.0), // #060505 at 0% opacity
                          Color(0xFF2F2C2C), // #2F2C2C at 100% opacity
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                if (_controller != null && _controller!.value.isInitialized)
                  Positioned(
                    bottom: 200, // Set desired height from the bottom
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 4), // Padding for the right side only
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isMutedList[_currentIndex]
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                              color: Colors.white,
                              size: 25,
                            ),
                            onPressed: _toggleMuteUnmute,
                          ),
                          GestureDetector(
                            onTap: () => _openReviewOverlay(
                                context, index), // Handle the tap for both
                            child: Column(
                              children: [
                                Image.asset(
                                  'packages/swirl_shortvideosdk/assets/images/icon_rating.png',
                                  width: 20,
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width: 30,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColor.ratingCountBackgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '888',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColor.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets
                                .zero, // Ensure no padding for the icon button
                            icon: Image.asset(
                              'packages/swirl_shortvideosdk/assets/images/icon_chat.png',
                              width: 25,
                              height: 25,
                            ),
                            onPressed: () => _openChatOverlay(context, index),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Back button
                Positioned(
                  top: 30,
                  right: 10,
                  child: IconButton(
                    icon: Image.asset(
                      'packages/swirl_shortvideosdk/assets/images/close.png',
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 35,
                  child: IconButton(
                    icon: Image.asset(
                      'packages/swirl_shortvideosdk/assets/images/icon_horizontal_dort.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () => _openVerticalOverlay(
                        context, index, widget.videoUrls.first),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 60,
                  child: IconButton(
                    icon: Image.asset(
                      'packages/swirl_shortvideosdk/assets/images/icon_cart.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                // Play/Pause button
                if (_controller != null &&
                    _controller!.value.isInitialized &&
                    _showControls)
                  Positioned(
                    child: IconButton(
                      icon: Icon(
                        _isPlayingList[_currentIndex]
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 48,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    child: CircleImageListView(
                      onVideoSelected: (index) {
                        _pageController.jumpToPage(index);
                        _expandCircleView();
                      },
                      initialIsExpanded: false, // Set initial expansion state
                      initialIndex:
                          index, // Pass the index of the currently playing video
                      images: _videoCoverImages
                          .map((video) => video.coverurl)
                          .toList(),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: VideoProgressIndicator(
                      _controller!,
                      allowScrubbing: true,
                      padding: EdgeInsets.zero,
                      colors: const VideoProgressColors(
                        playedColor: AppColor.playedColor,
                        bufferedColor: AppColor.bufferedColor,
                        backgroundColor: AppColor.productTextColor,
                      ),
                    ),
                  ),
                ),
                // Product List at the bottom
                Positioned(
                    bottom: 5, // Set desired height from the bottom
                    left: 0,
                    right: 0,
                    // child: ProductListWithIndicator(),
                    child: ProductListWithIndicator(
                      products: widget.products,
                    )
                    //  products: _products), // Pass the products
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
