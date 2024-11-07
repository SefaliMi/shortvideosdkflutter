import 'package:swirl_shortvideosdk/model/review.dart';

class Product {
  final String name;
  //final int price;
  final String price;
  final String link;
  final String image;
  final String discountPrice; // Changed to String
//  final int discountPrice;
  final String currencysymbols;
  final String avgRating;
  final String desription;
  final List<Review> pReviews;

  Product({
    required this.name,
    required this.price,
    required this.link,
    required this.image,
    required this.discountPrice,
    required this.currencysymbols,
    required this.avgRating,
    required this.desription,
    required this.pReviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'].toString(),
      link: json['link'],
      image: json['image'],
      discountPrice: json['discount_price'].toString(),
      currencysymbols: json['currencysymbols'],
      avgRating: json['avgRating'].toString(),
      desription: json['desription'],
      pReviews: List<Review>.from(
          json['pReviews'].map((item) => Review.fromJson(item))),
    );
  }
}
