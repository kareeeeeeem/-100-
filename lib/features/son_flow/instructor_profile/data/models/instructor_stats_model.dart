import 'package:json_annotation/json_annotation.dart';

part 'instructor_stats_model.g.dart';

@JsonSerializable()
class InstructorStatsModel {
  final String experience;
  final String students;
  final String courses;

  InstructorStatsModel({
    required this.experience,
    required this.students,
    required this.courses,
  });

  factory InstructorStatsModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorStatsModelToJson(this);
}
