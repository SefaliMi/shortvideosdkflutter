import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';

class CapacityListWidget extends StatelessWidget {
  final List<String> productsSize = [
    '12L',
    '17L',
    '21L',
    '25L',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Side Text
        Expanded(
          flex: 1,
          child: Text(
            'Capacity', // Left text
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'CircularStd',
              fontWeight: FontWeight.w500,
              color: AppColor.pricetTextColor,
            ),
          ),
        ),
        // Right Side ListView
        Expanded(
          flex: 1,
          child: Container(
            height: 45, // Set the height of the ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Horizontal scroll
              itemCount: productsSize.length, // Number of size items
              itemBuilder: (context, index) {
                return Container(
                  height: 36, // Set height to 36
                  width: 36, // Set width to 36
                  margin: EdgeInsets.symmetric(
                      horizontal: 4), // Spacing between items
                  decoration: BoxDecoration(
                    color: AppColor
                        .pricePercentageTextColor, // Background color for size item
                    borderRadius: BorderRadius.circular(4.0), // Rounded corners
                    border: Border.all(
                      color: AppColor.playedColor, // Border color
                      width: 0.5, // Border width
                    ),
                  ),
                  child: Center(
                    child: Text(
                      productsSize[index], // Size text
                      style: TextStyle(
                        color: AppColor.productTextColor,
                        fontSize: 12,
                        fontFamily: 'CircularStd',
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center, // Center text
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                      maxLines: 1, // Single line
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
