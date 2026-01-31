class CommentModel {
  final int id;
  final String userName;
  final String? userAvatar;
  final String commentText;
  final String createdAt;
  final int likesCount;
  final int dislikesCount;
  final int repliesCount;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.commentText,
    required this.createdAt,
    required this.likesCount,
    required this.dislikesCount,
    required this.repliesCount,
    required this.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'] ?? 0,
        userName: json['user_name'] ?? 'مستخدم',
        userAvatar: json['user_avatar'],
        commentText: json['comment_text'] ?? '',
        createdAt: json['created_at_human'] ?? '',
        likesCount: json['likes_count'] ?? 0,
        dislikesCount: json['dislikes_count'] ?? 0,
        repliesCount: json['replies_count'] ?? 0,
        replies: (json['replies'] as List?)
                ?.map((e) => CommentModel.fromJson(e))
                .toList() ??
            [],
      );
}

class CommentResponseModel {
  final bool status;
  final String message;
  final List<CommentModel> data;

  CommentResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CommentResponseModel.fromJson(Map<String, dynamic> json) =>
      CommentResponseModel(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        data: (json['data'] as List?)
                ?.map((e) => CommentModel.fromJson(e))
                .toList() ??
            [],
      );
}
