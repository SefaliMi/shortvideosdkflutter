import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';
import 'package:swirl_shortvideosdk/screens/bottomsheet_product_image.dart';
import 'package:swirl_shortvideosdk/screens/review_product_list_screen.dart';
import 'package:swirl_shortvideosdk/widgets/arrow_toggle_text_widget.dart';
import 'package:swirl_shortvideosdk/widgets/capacitylistwidget.dart';
import 'package:swirl_shortvideosdk/widgets/increment_decrement_widget.dart';
import 'package:swirl_shortvideosdk/model/product.dart';

class ProductListWithIndicator extends StatefulWidget {
  final List<Product> products;

  ProductListWithIndicator({required this.products});

  @override
  _ProductListWithIndicatorState createState() =>
      _ProductListWithIndicatorState();
}

class _ProductListWithIndicatorState extends State<ProductListWithIndicator> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
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

  void _openBottomSheet(BuildContext context, int index) {
    final ScrollController _scrollController = ScrollController();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        bool isExpanded = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
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
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'CircularStd',
                              fontWeight: FontWeight.w700,
                              color: AppColor.productTextColor,
                            ),
                          ),
                          Image.asset(
                            isExpanded
                                ? 'packages/swirl_shortvideosdk/assets/images/up_arrow.png'
                                : 'packages/swirl_shortvideosdk/assets/images/down_arrow.png',
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColor.pricePercentageColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.products[index].avgRating,
                          style: const TextStyle(
                            fontFamily: 'CircularStd',
                            color: AppColor.greyColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 1,
                          height: 10,
                          color: AppColor.plusBackgroundColor,
                        ),
                        const SizedBox(width: 5),
                        Image.asset(
                          'packages/swirl_shortvideosdk/assets/images/ic_person.png',
                          width: 14,
                          height: 14,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "200",
                          style: TextStyle(
                            color: AppColor.greyColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'CircularStd',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 10, color: AppColor.dividerColor),

                  // Expanded scrollable content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            if (isExpanded) ...[
                              SizedBox(
                                height: 300, // Set a specific height for review
                                child: ReviewProductListScreen(
                                    reviews: widget.products[index].pReviews),
                              ),
                              SizedBox(
                                height: 10.0,
                              )
                            ] else ...[
                              SizedBox(
                                  height: 170,
                                  child: BottomSheetProductImage()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 2),
                                  Image.asset(
                                    'packages/swirl_shortvideosdk/assets/images/emoji_trophy.png',
                                    width: 14,
                                    height: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  const Flexible(
                                    child: Text(
                                      "Bestseller",
                                      style: TextStyle(
                                        fontFamily: 'CircularStd',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: AppColor.orangeTitle,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.products[index].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'CircularStd',
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.pricetTextColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '${widget.products[index].currencysymbols}${widget.products[index].price}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'CircularStd',
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.pricetTextColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${widget.products[index].currencysymbols}${widget.products[index].discountPrice}',
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor:
                                          AppColor.discountPriceTextColor,
                                      fontSize: 18,
                                      fontFamily: 'CircularStd',
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.discountPriceTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Color',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'CircularStd',
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.pricetTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Deepdlive bluee',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'CircularStd',
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.productTextColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              CapacityListWidget(),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Qty.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'CircularStd',
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.pricetTextColor,
                                    ),
                                  ),
                                  IncrementDecrementWidget(),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ArrowToggleTextWidget(
                                  scrollController:
                                      _scrollController, // Pass the ScrollController here
                                  description:
                                      widget.products[index].desription),
                            ],
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Conditional Material widget when expanded
                  if (isExpanded)
                    Material(
                      elevation: 4.0,
                      shadowColor: Colors.black.withOpacity(0.2),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.expandedBackgroundColor,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // Use Expanded here
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      widget.products[index].image,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          8), // Increased spacing for better aesthetics
                                  Flexible(
                                    // Use Flexible for text
                                    child: Text(
                                      widget.products[index].name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'CircularStd',
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.productDetailTextColor,
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // Handle overflow
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              icon: Image.asset(
                                'packages/swirl_shortvideosdk/assets/images/expand_diagonal_line.png',
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Buttons always visible at the bottom
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 35,
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColor.productDetailTextColor,
                              width: 1.0,
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Add your button action here
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'packages/swirl_shortvideosdk/assets/images/add_to_cart.png',
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'CircularStd',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              primary: AppColor.productDetailTextColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 10,
                        ),
                        Container(
                          height: 35,
                          width: 160,
                          decoration: BoxDecoration(
                            color: AppColor.pricetTextColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Add your button action here
                            },
                            child: const Text(
                              "Buy Now",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'CircularStd',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              primary: AppColor.buttonTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
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
    return SizedBox(
      height: 154,
      child: Column(
        children: [
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
                    discount: widget.products[index].discountPrice,
                    price: widget.products[index].price,
                    avgRating: widget.products[index].avgRating,
                    currencysymbols: widget.products[index].currencysymbols,
                    onTap: () =>
                        _openBottomSheet(context, index), // Pass the index
                  ),
                );
              },
            ),
          ),
          // Conditionally show Page Indicator
          if (widget.products.length > 1) // Only show if more than 1 item
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.products.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 10.0 : 6.0,
                    height: _currentPage == index ? 10.0 : 6.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? const Color(0xFFFFFFFF)
                            : const Color(0x80FFFFFF)),
                  );
                }),
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
  final String discount;
  final String price;
  final String avgRating;
  final String currencysymbols;
  final VoidCallback onTap; // Add this line

  const ProductItem({
    required this.image,
    required this.title,
    required this.discount,
    required this.price,
    required this.avgRating,
    required this.currencysymbols,
    required this.onTap, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Invoke onTap when tapped
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns the container to the left
        children: [
          Container(
            alignment: Alignment.center,
            height: 20,
            width: 90,
            margin:
                const EdgeInsets.symmetric(vertical: 0), // No vertical margin
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.zero, // Curve bottom left
                bottomRight: Radius.zero,
              ),
              color: AppColor.orange,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Aligns items to the start
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 2), // Adjust padding to fit
                  child: Image.asset(
                    'packages/swirl_shortvideosdk/assets/images/emoji_trophy.png',
                    width: 15,
                    height: 15,
                  ),
                ),
                const Flexible(
                  child: Text(
                    "Bestseller",
                    style: TextStyle(
                      fontFamily: 'CircularStd',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColor.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow
                        .ellipsis, // Ensures text fits within the container
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 0), // No vertical margin
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.productBackgroundColor,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Image on the left side
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5), // Curve top left
                          bottomLeft: Radius.circular(5), // Curve bottom left
                          topRight: Radius.zero, // No curve on top right
                          bottomRight: Radius.zero,
                        ),
                        child: Image.network(
                          image,
                          width: 90, // Adjusted width
                          height: 106, // Adjusted height
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Text information on the right side
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                              height: 16), // Adding some spacing at the top
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'CircularStd',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColor.productTextColor),
                          ),

                          const SizedBox(height: 1),
                          Row(
                            children: [
                              Text(
                                '$currencysymbols$price',
                                style: const TextStyle(
                                  fontFamily: 'CircularStd',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.pricetTextColor,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '$currencysymbols$discount',
                                style: const TextStyle(
                                  fontFamily: 'CircularStd',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor:
                                      AppColor.discountPriceTextColor,
                                  color: AppColor.discountPriceTextColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ), // Padding inside the container
                                decoration: BoxDecoration(
                                  color: AppColor
                                      .pricePercentageColor, // Background color for the text
                                  borderRadius: BorderRadius.circular(
                                      3), // Curved corners
                                ),
                                child: const Text(
                                  "30%",
                                  style: TextStyle(
                                    fontFamily: 'CircularStd',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppColor.pricePercentageTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 35, // Set the height of the button
                                width: 160, // Set the width of the button
                                decoration: BoxDecoration(
                                  color: AppColor
                                      .pricetTextColor, // Background color
                                  borderRadius:
                                      BorderRadius.circular(5), // Border radius
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Add your button action here
                                  },
                                  child: const Text(
                                    "Buy Now",
                                    style: TextStyle(
                                      fontFamily: 'CircularStd',
                                      fontSize: 14, // Change the font size here
                                      fontWeight: FontWeight
                                          .bold, // Optional: Set font weight if needed
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    primary: AppColor.buttonTextColor,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Image.asset(
                                  'packages/swirl_shortvideosdk/assets/images/add_to_cart.png',
                                  width: 20,
                                  height: 20,
                                ),
                                onPressed: () {
                                  // Add your image button action here
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Positioned text with curve background in the top-right corner
                Positioned(
                  top: 0, // Adjust this value to position vertically
                  right: 0, // Adjust this value to position horizontally
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: AppColor
                          .ratingBackgroundColor, // Background color for the text
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5), // Curve on top right
                        bottomLeft: Radius.circular(5), // Curve on bottom left
                      ),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min, // Adjusts row size to fit content
                      children: [
                        const Icon(
                          Icons.star, // Replace with your desired icon
                          color: AppColor.pricePercentageColor, // Icon color
                          size: 12, // Adjust icon size as needed
                        ),
                        const SizedBox(width: 4), // Space between icon and text
                        Text(
                          avgRating,
                          style: const TextStyle(
                            fontFamily: 'CircularStd',
                            color: AppColor.ratingTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
