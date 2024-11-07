import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';

class IncrementDecrementWidget extends StatefulWidget {
  @override
  _IncrementDecrementWidgetState createState() =>
      _IncrementDecrementWidgetState();
}

class _IncrementDecrementWidgetState extends State<IncrementDecrementWidget> {
  int value = 1; // Start from 1

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrement Button
        GestureDetector(
          onTap: () {
            setState(() {
              if (value > 1) value--;
            });
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.plusBackgroundColor),
              // color: AppColor.plusBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'packages/swirl_shortvideosdk/assets/images/minus.png',
                height: 20,
                width: 20,
              ),
            ),
          ),
        ),
        SizedBox(width: 10), // Spacing between the buttons and value
        // Value Display in a Circle
        Center(
          child: Text(
            "$value",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'CircularStd',
              fontWeight: FontWeight.w400,
              color: AppColor.pricetTextColor,
            ),
          ),
        ),
        SizedBox(width: 10), // Spacing between the buttons and value
        // Increment Button
        GestureDetector(
          onTap: () {
            setState(() {
              value++;
            });
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.plusBackgroundColor),
              // color: AppColor.plusBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'packages/swirl_shortvideosdk/assets/images/plus.png',
                height: 20,
                width: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
