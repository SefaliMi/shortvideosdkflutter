import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';

class ArrowToggleTextWidget extends StatefulWidget {
  final String description; // Add this line
  final ScrollController scrollController;

  // Update the constructor
  const ArrowToggleTextWidget(
      {Key? key, required this.scrollController, required this.description})
      : super(key: key);

  @override
  _ArrowToggleTextWidgetState createState() => _ArrowToggleTextWidgetState();
}

class _ArrowToggleTextWidgetState extends State<ArrowToggleTextWidget> {
  bool _isTextVisible = false;

  void _toggleTextVisibility() {
    setState(() {
      _isTextVisible = !_isTextVisible;
    });
    // Scroll to the bottom of the widget when text becomes visible
    if (_isTextVisible) {
      // Add a delay to allow the widget to rebuild
      Future.delayed(const Duration(milliseconds: 100), () {
        widget.scrollController.jumpTo(
          widget.scrollController.position.maxScrollExtent,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'CircularStd',
                fontWeight: FontWeight.w500,
                color: AppColor.pricetTextColor,
              ),
            ),
            GestureDetector(
              onTap: _toggleTextVisibility,
              child: Icon(
                _isTextVisible
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 26,
                color: AppColor.pricetTextColor,
              ),
            ),
          ],
        ),
        if (_isTextVisible)
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the start (left)
            children: [
              Divider(
                color: Colors.grey,
                height: 1.0,
              ), // Horizontal line

              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
