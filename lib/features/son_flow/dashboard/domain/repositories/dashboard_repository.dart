import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/dashboard/data/models/dashboard_stats_model.dart';

abstract class DashboardRepository {
  Future<Result<DashboardStatsModel>> getDashboardStats();
}
