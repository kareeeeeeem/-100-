// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorStatsModel _$InstructorStatsModelFromJson(
  Map<String, dynamic> json,
) => InstructorStatsModel(
  experience: json['experience'] as String,
  students: json['students'] as String,
  courses: json['courses'] as String,
);

Map<String, dynamic> _$InstructorStatsModelToJson(
  InstructorStatsModel instance,
) => <String, dynamic>{
  'experience': instance.experience,
  'students': instance.students,
  'courses': instance.courses,
};
