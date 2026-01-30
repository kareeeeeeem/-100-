import 'package:json_annotation/json_annotation.dart';

part 'my_courses_response_model.g.dart';

@JsonSerializable()
class MyCoursesResponseModel {
  final bool status;
  final String message;
  final List<MyCourseItemModel> data;

  MyCoursesResponseModel({required this.status, required this.message, required this.data});

  factory MyCoursesResponseModel.fromJson(Map<String, dynamic> json) => _$MyCoursesResponseModelFromJson(json);
}
@JsonSerializable()
class MyCourseItemModel {
  final dynamic id; // غيرها لـ dynamic عشان الـ API باعتها String بس أحياناً بتكون Int
  final String title;
  final String duration;
  final String category;
  @JsonKey(name: 'progress_percentage')
  final String? progressPercentage;
  final String? thumbnail;
  @JsonKey(name: 'lessons_count')
  final String? lessonsCount; // أضف هذا الحقل لأنه مطلوب في الـ Schema
  final InstructorModel instructor;

  MyCourseItemModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.category,
    this.progressPercentage,
    this.thumbnail,
    this.lessonsCount,
    required this.instructor,
  });

  factory MyCourseItemModel.fromJson(Map<String, dynamic> json) => _$MyCourseItemModelFromJson(json);
}
@JsonSerializable()
class InstructorModel {
  final String name;
  final String? image;

  InstructorModel({required this.name, this.image});

  factory InstructorModel.fromJson(Map<String, dynamic> json) => _$InstructorModelFromJson(json);
}