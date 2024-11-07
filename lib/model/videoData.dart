import 'package:swirl_shortvideosdk/model/swirlsData.dart';

class VideoData {
  final bool success;
  final SwirlsData swirls;

  VideoData({required this.success, required this.swirls});

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      success: json['success'],
      swirls: SwirlsData.fromJson(json['data']['swirls']),
    );
  }
}
