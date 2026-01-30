// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_courses_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyCoursesResponseModel _$MyCoursesResponseModelFromJson(
  Map<String, dynamic> json,
) => MyCoursesResponseModel(
  status: json['status'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => MyCourseItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MyCoursesResponseModelToJson(
  MyCoursesResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

MyCourseItemModel _$MyCourseItemModelFromJson(Map<String, dynamic> json) =>
    MyCourseItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      category: json['category'] as String,
      progressPercentage: json['progress_percentage'] as String?,
      thumbnail: json['thumbnail'] as String?,
      instructor: InstructorModel.fromJson(
        json['instructor'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MyCourseItemModelToJson(MyCourseItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': instance.duration,
      'category': instance.category,
      'progress_percentage': instance.progressPercentage,
      'thumbnail': instance.thumbnail,
      'instructor': instance.instructor,
    };

InstructorModel _$InstructorModelFromJson(Map<String, dynamic> json) =>
    InstructorModel(
      name: json['name'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$InstructorModelToJson(InstructorModel instance) =>
    <String, dynamic>{'name': instance.name, 'image': instance.image};
