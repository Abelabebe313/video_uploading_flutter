class Like {
  final String id;
  final String userId;
  final String postId;
  final int like;

  Like({
    required this.id,
    required this.userId,
    required this.postId,
    required this.like,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'postId': postId,
      'like': like,
    };
  }

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      like: json['like'],
    );
  }
}
