import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/live_sessions/data/models/live_session_model.dart';

class LiveSessionApiService {
  final ApiService _apiService;
  final JwtService _jwtService;

  LiveSessionApiService(this._apiService, this._jwtService);

  Future<LiveSessionsDataModel> getLiveSessions() async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.liveSessions,
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = LiveSessionsResponseModel.fromJson(response);
    return responseModel.data;
  }

  Future<LiveSessionsDataModel> getSectionLiveSessions(String sectionId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.sectionLiveSessions(sectionId),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = LiveSessionsResponseModel.fromJson(response);
    return responseModel.data;
  }

  Future<JoinSessionDataModel> joinSession(String sessionId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.joinLiveSession(sessionId),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = JoinSessionResponseModel.fromJson(response);
    return responseModel.data;
  }
}
