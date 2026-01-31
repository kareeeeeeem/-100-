import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/features/son_flow/login/data/model/live_session_model.dart';
class LiveSessionsApiService {
  final ApiService _apiService;

  LiveSessionsApiService(this._apiService);

  // جلب القائمة
  // جلب القائمة
  Future<LiveSessionModel> getLiveSessions() async {
    final response = await _apiService.get(
      'live-sessions', 
      headers: {'requiresAuthKey': 'true'}, // حولناها لـ String
    ); 
    return LiveSessionModel.fromJson(response);
  }

  // الانضمام
  Future<String> joinSession(String id) async {
    final response = await _apiService.get(
      'live-sessions/$id/join', 
      headers: {'requiresAuthKey': 'true'}, // حولناها لـ String
    );
    
    if (response['status'] == true) {
      return response['data']['join_url'];
    } else {
      throw Exception(response['message'] ?? 'خطأ في جلب رابط الانضمام');
    }
  }
}