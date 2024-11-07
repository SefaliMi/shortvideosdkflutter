import 'package:flutter/material.dart';

class ExpandableHorizontalThumbnailList extends StatefulWidget {
  @override
  _ExpandableHorizontalThumbnailListState createState() =>
      _ExpandableHorizontalThumbnailListState();
}

class _ExpandableHorizontalThumbnailListState
    extends State<ExpandableHorizontalThumbnailList> {
  bool isExpanded = false;

  final List<String> thumbnails = [
    'https://static.contrado.com/resources/images/2020-12/165904/tote-bags-designed-online-1049209_l.jpeg',
    'https://www.marni.com/on/demandware.static/-/Sites-marni-master-catalog/default/dwaf730ed1/images/large/SBMP0133U0_LV589_00N99_D.jpg',
    'https://www.ambromanufacturing.com/wp-content/uploads/2022/12/Tote-Bags-In-Bulk.jpg',
    'https://static.contrado.com/resources/images/2020-12/165904/tote-bags-designed-online-1049209_l.jpeg',
    'https://www.marni.com/on/demandware.static/-/Sites-marni-master-catalog/default/dwaf730ed1/images/large/SBMP0133U0_LV589_00N99_D.jpg',
    'https://www.ambromanufacturing.com/wp-content/uploads/2022/12/Tote-Bags-In-Bulk.jpg',
    'https://static.contrado.com/resources/images/2020-12/165904/tote-bags-designed-online-1049209_l.jpeg',
    'https://www.marni.com/on/demandware.static/-/Sites-marni-master-catalog/default/dwaf730ed1/images/large/SBMP0133U0_LV589_00N99_D.jpg',
    'https://www.ambromanufacturing.com/wp-content/uploads/2022/12/Tote-Bags-In-Bulk.jpg',
  ];

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: toggleExpansion,
          child: Text(isExpanded ? "Collapse" : "Expand"),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(isExpanded ? 0 : 30),
              bottomRight: Radius.circular(isExpanded ? 0 : 30),
            ),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isExpanded ? MediaQuery.of(context).size.width * 0.8 : 60,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: isExpanded ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Row(
                    children: thumbnails.map((url) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            url,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (!isExpanded)
                  Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 30,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
