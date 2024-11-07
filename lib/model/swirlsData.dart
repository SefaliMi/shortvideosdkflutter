import 'package:swirl_shortvideosdk/model/customization.dart';
import 'package:swirl_shortvideosdk/model/video.dart';

class SwirlsData {
  final Customization customization;
  final List<Video> videos;

  SwirlsData({required this.customization, required this.videos});

  factory SwirlsData.fromJson(Map<String, dynamic> json) {
    return SwirlsData(
      customization: Customization.fromJson(json['customization']),
      videos: (json['video'] as List).map((v) => Video.fromJson(v)).toList(),
    );
  }
}
