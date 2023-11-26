class Video {
  final String id;
  final String userId;
  final String videoUrl;
  final String publishedAt;

  Video({
    required this.id,
    required this.userId,
    required this.videoUrl,
    required this.publishedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'video_url': videoUrl,
      'published_at': publishedAt,
    };
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      userId: json['user_id'],
      videoUrl: json['video_url'],
      publishedAt: json['published_at'],
    );
  }
}