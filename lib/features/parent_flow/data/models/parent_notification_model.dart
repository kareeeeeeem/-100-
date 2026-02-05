class ParentNotificationModel {
  final dynamic id;
  final String title;
  final String? message;
  final String? type;
  final String? senderImage;
  final bool isRead;
  final String createdAt;
  final String? targetId;

  ParentNotificationModel({
    required this.id,
    required this.title,
    this.message,
    this.type,
    this.senderImage,
    required this.isRead,
    required this.createdAt,
    this.targetId,
  });

  factory ParentNotificationModel.fromJson(Map<String, dynamic> json) {
    return ParentNotificationModel(
      id: json['id'],
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString(),
      type: json['type']?.toString(),
      senderImage: json['sender_image']?.toString(),
      isRead: json['is_read'] is bool ? json['is_read'] : (json['is_read']?.toString() == '1'),
      createdAt: json['created_at']?.toString() ?? '',
      targetId: json['target_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'sender_image': senderImage,
      'is_read': isRead,
      'created_at': createdAt,
      'target_id': targetId,
    };
  }
}
