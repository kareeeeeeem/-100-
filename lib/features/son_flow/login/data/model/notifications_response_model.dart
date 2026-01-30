class NotificationsResponseModel {
  final bool? status;
  final String? message;
  final List<NotificationItemModel>? data;

  NotificationsResponseModel({this.status, this.message, this.data});

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationsResponseModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null
            ? (json['data'] as List).map((e) => NotificationItemModel.fromJson(e)).toList()
            : null,
      );
}

class NotificationItemModel {
  final String? id;
  final String? title;
  final String? message;
  final String? type;
  final String? senderImage;
  final bool? isRead;
  final String? createdAt;
  final String? targetId;

  NotificationItemModel({
    this.id,
    this.title,
    this.message,
    this.type,
    this.senderImage,
    this.isRead,
    this.createdAt,
    this.targetId,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) =>
      NotificationItemModel(
        id: json['id']?.toString(),
        title: json['title'],
        message: json['message'],
        type: json['type'],
        senderImage: json['sender_image'],
        isRead: json['is_read'],
        createdAt: json['created_at'],
        targetId: json['target_id']?.toString(),
      );
}