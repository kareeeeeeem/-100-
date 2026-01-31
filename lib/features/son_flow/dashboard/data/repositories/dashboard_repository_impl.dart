import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/dashboard/data/data_sources/dashboard_api_service.dart';
import 'package:lms/features/son_flow/dashboard/data/models/dashboard_stats_model.dart';
import 'package:lms/features/son_flow/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardApiService _apiService;

  DashboardRepositoryImpl(this._apiService);

  @override
  Future<Result<DashboardStatsModel>> getDashboardStats() async {
    try {
      final response = await _apiService.getDashboardStats();
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }
}
