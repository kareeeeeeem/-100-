import 'package:lms/features/son_flow/dashboard/data/models/dashboard_stats_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardStatsLoaded extends DashboardState {
  final DashboardStatsModel stats;

  DashboardStatsLoaded(this.stats);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
