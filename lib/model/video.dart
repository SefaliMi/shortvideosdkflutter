import 'package:swirl_shortvideosdk/model/product.dart';

class Video {
  final String title;
  final String coverImage;
  final String slugUrl;
  final String videoUrl;
  final String summary;
  final int rating;
  final List<Product> products;

  Video({
    required this.title,
    required this.coverImage,
    required this.slugUrl,
    required this.videoUrl,
    required this.summary,
    required this.rating,
    required this.products,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['video_title'],
      coverImage: json['cover_image'],
      slugUrl: json['slug_url'],
      videoUrl: json['video_url'],
      summary: json['summary'],
      rating: json['rating'],
      products: (json['product'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }
}
// class Video {
//   final String videoTitle;
//   final String coverImage;
//   final String slugUrl;
//   final String jwMediaId;
//   final String productId;
//   final String designerId;
//   final String videoId;
//   final String productLink;
//   final String coverVideo;
//   final int videoLen;
//   final String totalViews;
//   final double rating;
//   final String ctaButton;
//   final String isLandscape;
//   final String videoUrl;
//   final String serverUrl;
//   final String ctaCustomization;
//   final String videoCtaBk;
//   final String videoCtaFk;
//   final String link;
//   final String summary;
//   final String reviewText;
//   final String image;
//   final String cName;
//   final Subtitles subtitles;
//   final List<Product> product;
//   final List<dynamic> productD;

//   Video({
//     required this.videoTitle,
//     required this.coverImage,
//     required this.slugUrl,
//     required this.jwMediaId,
//     required this.productId,
//     required this.designerId,
//     required this.videoId,
//     required this.productLink,
//     required this.coverVideo,
//     required this.videoLen,
//     required this.totalViews,
//     required this.rating,
//     required this.ctaButton,
//     required this.isLandscape,
//     required this.videoUrl,
//     required this.serverUrl,
//     required this.ctaCustomization,
//     required this.videoCtaBk,
//     required this.videoCtaFk,
//     required this.link,
//     required this.summary,
//     required this.reviewText,
//     required this.image,
//     required this.cName,
//     required this.subtitles,
//     required this.product,
//     required this.productD,
//   });

//   factory Video.fromJson(Map<String, dynamic> json) {
//     return Video(
//       videoTitle: json['video_title'],
//       coverImage: json['cover_image'],
//       slugUrl: json['slug_url'],
//       jwMediaId: json['jw_media_id'],
//       productId: json['product_id'],
//       designerId: json['designer_id'],
//       videoId: json['video_id'],
//       productLink: json['product_link'],
//       coverVideo: json['cover_video'],
//       videoLen: json['video_len'],
//       totalViews: json['total_views'] ?? '',
//       rating: (json['rating'] as num).toDouble(),
//       ctaButton: json['cta_button'],
//       isLandscape: json['is_landscape'],
//       videoUrl: json['video_url'],
//       serverUrl: json['server_url'],
//       ctaCustomization: json['cta_customization'],
//       videoCtaBk: json['video_cta_bk'],
//       videoCtaFk: json['video_cta_fk'],
//       link: json['link'],
//       summary: json['summary'],
//       reviewText: json['reviewText'],
//       image: json['image'],
//       cName: json['c_name'],
//       subtitles: Subtitles.fromJson(json['subtitles']),
//       product: List<Product>.from(
//           json['product'].map((item) => Product.fromJson(item))),
//       productD: List<dynamic>.from(json['product_d'] ?? []),
//     );
//   }
// }
