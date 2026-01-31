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
  final dynamic id; 
  final String title;
  final String duration;
  final String category;
  
  @JsonKey(name: 'progress_percentage')
  final dynamic progressPercentage; // غيرها لـ dynamic
  
  final String? thumbnail;
  
  @JsonKey(name: 'lessons_count')
  final dynamic lessonsCount; // غيرها لـ dynamic

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

  // دوال مساعدة عشان تحول القيم لنصوص بأمان في الـ UI
  String get progressText => progressPercentage?.toString() ?? "0";
  String get lessonsCountText => lessonsCount?.toString() ?? "0";

  factory MyCourseItemModel.fromJson(Map<String, dynamic> json) {
    return MyCourseItemModel(
      id: json['id'],
      title: (json['title']?.toString() ?? '').trim(),
      duration: (json['duration']?.toString() ?? '').trim(),
      category: (json['category']?.toString() ?? '').trim(),
      progressPercentage: json['progress_percentage'],
      thumbnail: (json['thumbnail']?.toString() ?? '').trim(),
      lessonsCount: json['lessons_count'],
      instructor: InstructorModel.fromJson(json['instructor'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => _$MyCourseItemModelToJson(this);
}

@JsonSerializable()
class InstructorModel {
  final String name;
  final String? image;

  InstructorModel({required this.name, this.image});

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      name: (json['name']?.toString() ?? '').trim(),
      image: (json['image']?.toString() ?? '').trim(),
    );
  }
}