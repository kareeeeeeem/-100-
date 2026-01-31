import 'package:json_annotation/json_annotation.dart';

part 'parent_notification_model.g.dart';

@JsonSerializable()
class ParentNotificationModel {
  final String id;
  final String title;
  final String body;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'read_at')
  final String? readAt;

  bool get isRead => readAt != null;

  ParentNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.readAt,
  });

  factory ParentNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$ParentNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParentNotificationModelToJson(this);
}
