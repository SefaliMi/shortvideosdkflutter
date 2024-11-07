import 'package:flutter/material.dart';
import 'package:swirl_shortvideosdk/constants/colors.dart';

class CircleImageListView extends StatefulWidget {
  final Function(int) onVideoSelected;
  final bool initialIsExpanded;
  final int initialIndex;
  final List<String> images;

  CircleImageListView({
    required this.onVideoSelected,
    required this.initialIsExpanded,
    required this.initialIndex,
    required this.images,
  });

  @override
  _CircleImageListViewState createState() => _CircleImageListViewState();
}

class _CircleImageListViewState extends State<CircleImageListView> {
  late bool isExpanded;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();

    // Ensure the image list is not empty, else handle it safely
    if (widget.images.isNotEmpty) {
      selectedIndex = widget.initialIndex.clamp(0, widget.images.length - 1);
    } else {
      selectedIndex = -1; // No valid selection if list is empty
    }

    isExpanded = widget.initialIsExpanded;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate total width of items
    double totalItemsWidth = widget.images.isNotEmpty
        ? widget.images.length * 40 + (widget.images.length - 1) * 1
        : 0;

    bool isFullWidth = totalItemsWidth >= screenWidth;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded; // Toggle expansion
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: AppColor.curvedListColor,
                borderRadius: isExpanded || isFullWidth
                    ? null // No curve when expanded or full width
                    : const BorderRadius.horizontal(right: Radius.circular(30)),
              ),
              width: isExpanded ? screenWidth : 55,
              height: 50,
              child: widget.images.isEmpty
                  ? Center(
                      child: Text(
                          'No images available')) // Gracefully handle empty list
                  : (isExpanded && isFullWidth
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                              List.generate(widget.images.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index; // Update selection
                                });
                                widget.onVideoSelected(
                                    index); // Notify parent of selection
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: CircleImageView(
                                  imageUrl: widget.images[index],
                                  isSelected: selectedIndex ==
                                      index, // Highlight selected item
                                ),
                              ),
                            );
                          }),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: isExpanded ? widget.images.length : 1,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index; // Update selection
                                });
                                widget.onVideoSelected(
                                    index); // Notify parent of selection
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: CircleImageView(
                                  imageUrl: widget.images[index],
                                  isSelected: selectedIndex ==
                                      index, // Highlight selected item
                                ),
                              ),
                            );
                          },
                        )),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleImageView extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;

  CircleImageView({required this.imageUrl, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? AppColor.white
              : Colors.transparent, // Highlight if selected
          width: 1.0,
        ),
        image: imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null, // Handle empty image case
      ),
    );
  }
}
