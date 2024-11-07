import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';
import 'package:swirl_shortvideosdk/screens/review_product_list_screen.dart';
import 'package:swirl_shortvideosdk/model/product.dart';
import 'package:swirl_shortvideosdk/model/review.dart';

class ProductListReviewScreen extends StatefulWidget {
  final List<Product> products;

  ProductListReviewScreen({required this.products});

  @override
  _ProductListReviewScreenState createState() =>
      _ProductListReviewScreenState();
}

class _ProductListReviewScreenState extends State<ProductListReviewScreen> {
  // PageController _pageController = PageController(viewportFraction: 0.9);
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.products.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentPage == index ? 10.0 : 6.0,
                  height: _currentPage == index ? 10.0 : 6.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Color(0xFF2E2E33)
                        : Color(0xFFD9D9D9),
                  ),
                );
              }),
            ),
          ),
          // Page Indicator
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProductItem(
                    image: widget.products[index].image,
                    title: widget.products[index].name,
                    discountprice: widget.products[index].discountPrice,
                    price: widget.products[index].price,
                    currencySymbol: widget.products[index].currencysymbols,
                    pReviews: widget.products[index].pReviews,
                    avgRating: widget.products[index].avgRating,
                    // onTap: () =>
                    //     _openBottomSheet(context, index), // Pass the index
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for a product item
class ProductItem extends StatelessWidget {
  final String image;
  final String title;
  final String discountprice;
  final String price;
  final String currencySymbol;
  final List<Review> pReviews;
  final String avgRating;
  // final VoidCallback onTap; // Add this line
  const ProductItem({
    required this.image,
    required this.title,
    required this.discountprice,
    required this.currencySymbol,
    required this.price,
    required this.pReviews,
    required this.avgRating,
    // required this.onTap, // Add this line
  });

//   @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Align "Bestseller" to the right
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min, // Keep row size minimal
                children: [
                  const SizedBox(width: 42),
                  Image.asset(
                    'packages/swirl_shortvideosdk/assets/images/emoji_trophy.png',
                    width: 15,
                    height: 15,
                  ),
                  const SizedBox(width: 2),
                  const Flexible(
                    child: Text(
                      "Bestseller",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        fontFamily: 'CircularStd',
                        color: AppColor.orange,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                // Image on the left side
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Center(
                      child: Image.network(
                        image,
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 2),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'CircularStd',
                            color: AppColor.productTextColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '$currencySymbol$price',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'CircularStd',
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.greyColor,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  '$currencySymbol$discountprice',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor:
                                        AppColor.discountPriceTextColor,
                                    fontFamily: 'CircularStd',
                                    color: AppColor.discountPriceTextColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: AppColor.pricePercentageColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Text(
                                    "30%",
                                    style: TextStyle(
                                      fontFamily: 'CircularStd',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColor.pricePercentageTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColor.pricePercentageColor,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  avgRating,
                                  style: TextStyle(
                                    fontFamily: 'CircularStd',
                                    color: AppColor.ratingTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  width: 1,
                                  height: 10,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 5),
                                Image.asset(
                                  'packages/swirl_shortvideosdk/assets/images/ic_person.png',
                                  width: 10,
                                  height: 10,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "200",
                                  style: TextStyle(
                                    fontFamily: 'CircularStd',
                                    color: AppColor.ratingTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 300, // Set a specific height
              child: ReviewProductListScreen(reviews: pReviews),
            ),
          ],
        ),
      ],
    );
  }
}
