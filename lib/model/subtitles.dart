class Subtitles {
  final String arabic;
  final String english;

  Subtitles({
    required this.arabic,
    required this.english,
  });

  factory Subtitles.fromJson(Map<String, dynamic> json) {
    return Subtitles(
      arabic: json['arabic'],
      english: json['english'],
    );
  }
}
