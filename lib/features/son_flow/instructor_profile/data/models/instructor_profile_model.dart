import 'package:json_annotation/json_annotation.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/instructor_profile/data/models/assistant_model.dart';
import 'package:lms/features/son_flow/instructor_profile/data/models/instructor_stats_model.dart';

part 'instructor_profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InstructorProfileModel {
  final String id;
  final String name;
  final String? avatar;
  final String bio;
  final InstructorStatsModel stats;
  final List<AssistantModel> assistants;
  @JsonKey(name: 'related_courses')
  final List<CourseModel> relatedCourses;

  InstructorProfileModel({
    required this.id,
    required this.name,
    this.avatar,
    required this.bio,
    required this.stats,
    required this.assistants,
    required this.relatedCourses,
  });

  factory InstructorProfileModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorProfileModelToJson(this);
}

@JsonSerializable()
class InstructorProfileResponseModel {
  final bool status;
  final String message;
  final InstructorProfileModel data;
  final dynamic errors;

  InstructorProfileResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory InstructorProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorProfileResponseModelToJson(this);
}
