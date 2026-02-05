// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentNotificationModel _$ParentNotificationModelFromJson(
  Map<String, dynamic> json,
) => ParentNotificationModel(
  id: json['id'],
  title: json['title'] as String,
  message: json['message'] as String?,
  type: json['type'] as String?,
  senderImage: json['sender_image'] as String?,
  isRead: json['is_read'] as bool,
  createdAt: json['created_at'] as String,
  targetId: json['target_id'] as String?,
);

Map<String, dynamic> _$ParentNotificationModelToJson(
  ParentNotificationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'type': instance.type,
  'sender_image': instance.senderImage,
  'is_read': instance.isRead,
  'created_at': instance.createdAt,
  'target_id': instance.targetId,
};
