// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentNotificationModel _$ParentNotificationModelFromJson(
  Map<String, dynamic> json,
) => ParentNotificationModel(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  createdAt: json['created_at'] as String,
  readAt: json['read_at'] as String?,
);

Map<String, dynamic> _$ParentNotificationModelToJson(
  ParentNotificationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'created_at': instance.createdAt,
  'read_at': instance.readAt,
};
