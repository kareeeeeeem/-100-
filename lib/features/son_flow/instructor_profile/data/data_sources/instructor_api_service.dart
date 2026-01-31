import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/instructor_profile/data/models/instructor_profile_model.dart';

class InstructorApiService {
  final ApiService _apiService;
  final JwtService _jwtService;

  InstructorApiService(this._apiService, this._jwtService);

  Future<InstructorProfileModel> getInstructorProfile(String instructorId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.instructorProfile(instructorId),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = InstructorProfileResponseModel.fromJson(response);
    return responseModel.data;
  }
}
