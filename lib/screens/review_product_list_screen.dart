import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';
import 'package:swirl_shortvideosdk/model/review.dart';

class ReviewProductListScreen extends StatelessWidget {
  final List<Review> reviews;

  const ReviewProductListScreen({Key? key, required this.reviews})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        // padding: const EdgeInsets.only(bottom: 10.0, top: 2.0),
        padding: const EdgeInsets.only(top: 2.0),
        child: ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColor.expandedBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 2,
                      //   height: 154,
                      decoration: BoxDecoration(
                        color: AppColor.verticalColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < reviews[index].cRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: AppColor.pricePercentageColor,
                                  size: 16,
                                );
                              }),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reviews[index].cComment,
                              style: const TextStyle(
                                  fontFamily: 'CircularStd',
                                  color: AppColor.productTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    "https://images.pexels.com/photos/1758144/pexels-photo-1758144.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", // Image URL
                                    width: 26, // Image width
                                    height: 26, // Image height
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  reviews[index].cName,
                                  style: const TextStyle(
                                      fontFamily: 'CircularStd',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.pricetTextColor),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  reviews[index].createdAt,
                                  style: const TextStyle(
                                    fontFamily: 'CircularStd',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.plusColor, // Subtitle color
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
