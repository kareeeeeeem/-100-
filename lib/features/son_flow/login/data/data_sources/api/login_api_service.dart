import 'package:lms/features/son_flow/login/data/model/login_request_model.dart';
import 'package:lms/features/son_flow/login/data/model/login_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/social_login_request_model.dart';
import 'package:lms/features/son_flow/login/data/model/forgot_password_models.dart';

abstract class LoginApiService {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<LoginResponseModel> socialLogin(SocialLoginRequestModel request);
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest request);
  Future<AuthDefaultResponse> verifyOtp(VerifyOtpRequest request);
  Future<AuthDefaultResponse> resetPassword(ResetPasswordRequest request);
}
