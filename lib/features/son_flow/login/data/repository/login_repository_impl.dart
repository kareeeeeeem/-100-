import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/core/service/device_info_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/login/data/data_sources/api/login_api_service.dart';
import 'package:lms/features/son_flow/login/data/model/login_request_model.dart';
import 'package:lms/features/son_flow/login/data/model/login_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/social_login_request_model.dart';
import 'package:lms/features/son_flow/login/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginApiService loginApiService;
  final DeviceInfoService deviceInfoService;
  final JwtService jwtService;

  const LoginRepositoryImpl(
    this.loginApiService,
    this.deviceInfoService,
    this.jwtService,
  );
  @override
  Future<Result<LoginResponseModel>> login(LoginRequestModel request) async {
    try {
      final deviceId = await deviceInfoService.getDeviceId();
      final response = await loginApiService.login(
        request.copyWith(deviceId: deviceId),
      );
      
      await _saveUserData(response);

      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<LoginResponseModel>> socialLogin(SocialLoginRequestModel request) async {
    try {
      final deviceId = await deviceInfoService.getDeviceId();
      final response = await loginApiService.socialLogin(
        SocialLoginRequestModel(
          name: request.name,
          email: request.email,
          provider: request.provider,
          providerId: request.providerId,
          deviceId: deviceId,
        ),
      );
      
      await _saveUserData(response);

      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  Future<void> _saveUserData(LoginResponseModel response) async {
    // حفظ التوكن
    await jwtService.saveAccessToken(response.data.token);
    
    // حفظ نوع المستخدم
    await jwtService.saveUserType(response.data.user.userType); 
    await jwtService.saveUserName(response.data.user.name); 
    
    if (response.data.user.image != null) {
      await jwtService.saveUserAvatar(response.data.user.image!);
    }
  }
}
