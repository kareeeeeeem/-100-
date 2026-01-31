// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorProfileModel _$InstructorProfileModelFromJson(
  Map<String, dynamic> json,
) => InstructorProfileModel(
  id: json['id'] as String,
  name: json['name'] as String,
  avatar: json['avatar'] as String?,
  bio: json['bio'] as String,
  stats: InstructorStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
  assistants: (json['assistants'] as List<dynamic>)
      .map((e) => AssistantModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  relatedCourses: (json['related_courses'] as List<dynamic>)
      .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InstructorProfileModelToJson(
  InstructorProfileModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar': instance.avatar,
  'bio': instance.bio,
  'stats': instance.stats.toJson(),
  'assistants': instance.assistants.map((e) => e.toJson()).toList(),
  'related_courses': instance.relatedCourses.map((e) => e.toJson()).toList(),
};

InstructorProfileResponseModel _$InstructorProfileResponseModelFromJson(
  Map<String, dynamic> json,
) => InstructorProfileResponseModel(
  status: json['status'] as bool,
  message: json['message'] as String,
  data: InstructorProfileModel.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'],
);

Map<String, dynamic> _$InstructorProfileResponseModelToJson(
  InstructorProfileResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
};
