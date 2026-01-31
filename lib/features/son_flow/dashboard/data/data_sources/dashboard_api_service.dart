import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/dashboard/data/models/dashboard_stats_model.dart';

class DashboardApiService {
  final ApiService _apiService;
  final JwtService _jwtService;

  DashboardApiService(this._apiService, this._jwtService);

  Future<DashboardStatsModel> getDashboardStats() async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.dashboardStats,
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = DashboardStatsResponseModel.fromJson(response);
    return responseModel.data;
  }
}
