// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    DashboardStatsModel(
      generalProgress: json['general_progress'],
      enrolledCourses: json['enrolled_courses'] as String,
      completedTasks: json['completed_tasks'] as String,
      certificates: json['certificates'] as String,
      studyHoursWeek: (json['study_hours_week'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
  DashboardStatsModel instance,
) => <String, dynamic>{
  'general_progress': instance.generalProgress,
  'enrolled_courses': instance.enrolledCourses,
  'completed_tasks': instance.completedTasks,
  'certificates': instance.certificates,
  'study_hours_week': instance.studyHoursWeek,
};

DashboardStatsResponseModel _$DashboardStatsResponseModelFromJson(
  Map<String, dynamic> json,
) => DashboardStatsResponseModel(
  status: json['status'] as bool,
  message: json['message'] as String,
  data: DashboardStatsModel.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'],
);

Map<String, dynamic> _$DashboardStatsResponseModelToJson(
  DashboardStatsResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
};
