import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/features/son_flow/login/data/data_sources/api/login_api_service.dart';
import 'package:lms/features/son_flow/login/data/model/login_request_model.dart';
import 'package:lms/features/son_flow/login/data/model/login_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/social_login_request_model.dart';

class LoginApiServiceImpl implements LoginApiService {
  final ApiService apiService;

  LoginApiServiceImpl(this.apiService);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await apiService.post(
      ApiConstants.login,
      body: request.toJson(),
    );
    return LoginResponseModel.fromJson(response);
  }

  @override
  Future<LoginResponseModel> socialLogin(SocialLoginRequestModel request) async {
    final response = await apiService.post(
      ApiConstants.socialLogin,
      body: request.toJson(),
    );
    return LoginResponseModel.fromJson(response);
  }
}
