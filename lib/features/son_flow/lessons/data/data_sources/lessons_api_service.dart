import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/lessons/data/models/lessons_response_model.dart';

abstract class LessonsApiService {
  Future<LessonsResponseModel> getSectionLessons(String sectionId);
}

class LessonsApiServiceImpl implements LessonsApiService {
  final ApiService _apiService;
  final JwtService _jwtService;

  LessonsApiServiceImpl(this._apiService, this._jwtService);

  @override
  Future<LessonsResponseModel> getSectionLessons(String sectionId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.sectionLessons(sectionId),
      headers: {'Authorization': 'Bearer $token'},
    );
    return LessonsResponseModel.fromJson(response);
  }
}
