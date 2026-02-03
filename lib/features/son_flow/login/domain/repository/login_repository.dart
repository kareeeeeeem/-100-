import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/login/data/model/login_request_model.dart';
import 'package:lms/features/son_flow/login/data/model/login_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/social_login_request_model.dart';

abstract class LoginRepository {
  Future<Result<LoginResponseModel>> login(LoginRequestModel request);
  Future<Result<LoginResponseModel>> socialLogin(SocialLoginRequestModel request);
}
