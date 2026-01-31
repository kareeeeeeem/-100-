import 'package:json_annotation/json_annotation.dart';

part 'assistant_model.g.dart';

@JsonSerializable()
class AssistantModel {
  final String name;
  final String? image;
  final String? role;

  AssistantModel({
    required this.name,
    this.image,
    this.role,
  });

  factory AssistantModel.fromJson(Map<String, dynamic> json) =>
      _$AssistantModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssistantModelToJson(this);
}
