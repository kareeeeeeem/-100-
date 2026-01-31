// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssistantModel _$AssistantModelFromJson(Map<String, dynamic> json) =>
    AssistantModel(
      name: json['name'] as String,
      image: json['image'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$AssistantModelToJson(AssistantModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'role': instance.role,
    };
