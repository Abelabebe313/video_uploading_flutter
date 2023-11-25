class Comment {
  final String id;
  final String userId;
  final String postId;
  final String comment;
  final String commentedAt;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.comment,
    required this.commentedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'postId': postId,
      'comment': comment,
      'commentedAt': commentedAt,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      comment: json['comment'],
      commentedAt: json['commentedAt'],
    );
  }
}
