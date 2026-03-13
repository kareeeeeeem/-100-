import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_model.g.dart';

@JsonSerializable()
class DashboardStatsModel {
  @JsonKey(name: 'general_progress')
  final dynamic generalProgress; // Can be number or 0

  @JsonKey(name: 'enrolled_courses')
  final String enrolledCourses;

  @JsonKey(name: 'completed_tasks')
  final String completedTasks;

  final String certificates;

  @JsonKey(name: 'study_hours_week')
  final List<int> studyHoursWeek;

  DashboardStatsModel({
    required this.generalProgress,
    required this.enrolledCourses,
    required this.completedTasks,
    required this.certificates,
    required this.studyHoursWeek,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);

  // Helper getter for progress as double
  double get progressValue {
    if (generalProgress is num) {
      return (generalProgress as num).toDouble();
    }
    return 0.0;
  }
}

@JsonSerializable()
class DashboardStatsResponseModel {
  final bool status;
  final String message;
  final DashboardStatsModel data;
  final dynamic errors;

  DashboardStatsResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory DashboardStatsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsResponseModelToJson(this);
}
