import 'package:flutter/material.dart';

class BottomSheetProductImage extends StatefulWidget {
  @override
  _BottomSheetProductImage createState() => _BottomSheetProductImage();
}

class _BottomSheetProductImage extends State<BottomSheetProductImage> {
  final List<Map<String, String>> productsImage = [
    {
      'image':
          'https://static.contrado.com/resources/images/2020-12/165904/tote-bags-designed-online-1049209_l.jpeg',
    },
    {
      'image':
          'https://www.marni.com/on/demandware.static/-/Sites-marni-master-catalog/default/dwaf730ed1/images/large/SBMP0133U0_LV589_00N99_D.jpg',
    },
    {
      'image':
          'https://www.ambromanufacturing.com/wp-content/uploads/2022/12/Tote-Bags-In-Bulk.jpg',
    },
  ];

  final PageController _pageController =
      PageController(viewportFraction: 0.8); // Adjust viewportFraction
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

//   @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 180,
        width: 205, // Adjust the width of the container as needed
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: productsImage.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ProductItem(
                      image: productsImage[index]['image']!,
                      containerHeight: 170, // Set height to 170
                      containerWidth: 170, // Set width to 170
                    ),
                  );
                },
                pageSnapping: true,
              ),
            ),
            // Conditionally display the Page Indicator
            if (productsImage.length > 1) // Only show if more than 1 item
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(productsImage.length, (index) {
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
          ],
        ),
      ),
    );
  }
}

// Widget for a product item
class ProductItem extends StatelessWidget {
  final String image;
  final double containerHeight;
  final double containerWidth;

  const ProductItem({
    required this.image,
    required this.containerHeight,
    required this.containerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth, // Set the container width
      height: containerHeight, // Set the container height
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          image,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
