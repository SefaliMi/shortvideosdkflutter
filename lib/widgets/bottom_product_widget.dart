import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';
import 'package:swirl_shortvideosdk/model/product.dart';

class BottomProductWidget extends StatelessWidget {
  final Product product; // Accept a Product object

  const BottomProductWidget(
      {super.key, required this.product}); // Constructor to accept product

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 4.0, bottom: 4.0, right: 4.0),
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.expandedBackgroundColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product.image, // Use the image from the product
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(0xFF334499),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '10',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 10,
                                fontFamily: 'CircularStd',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name, // Display product name
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'CircularStd',
                              color: AppColor.white),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                '${product.currencysymbols}${product.price}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  overflow:
                                      TextOverflow.ellipsis, // Handle overflow
                                  fontSize: 14,
                                  color: AppColor.white,
                                  fontFamily: 'CircularStd',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '${product.currencysymbols}${product.discountPrice}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: AppColor.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColor.white,
                                  fontFamily: 'CircularStd',
                                ),
                              ),
                              Visibility(
                                visible: false,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: AppColor.pricePercentageColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    '${product.discountPrice}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'CircularStd',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColor.pricePercentageTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
