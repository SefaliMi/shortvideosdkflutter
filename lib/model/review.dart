class Review {
  final String cComment;
  final String createdAt;
  final String cName;
  final double cRating;
  final int createdAtTime;

  Review({
    required this.cComment,
    required this.createdAt,
    required this.cName,
    required this.cRating,
    required this.createdAtTime,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      cComment: json['c_comment'],
      createdAt: json['created_at'],
      cName: json['c_name'],
      cRating: (json['c_rating'] as num).toDouble(),
      createdAtTime: json['created_at_time'],
    );
  }
}
