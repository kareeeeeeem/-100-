import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/core/service/device_info_service.dart';
import 'package:lms/features/son_flow/register/data/data_sources/api/register_api_service.dart';
import 'package:lms/features/son_flow/register/data/model/register_request_model.dart';
import 'package:lms/features/son_flow/register/data/model/register_response_model.dart';
import 'package:lms/features/son_flow/register/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterApiService loginApiService;
  final DeviceInfoService deviceInfoService;

  const RegisterRepositoryImpl(this.loginApiService, this.deviceInfoService);

  @override
  Future<Result<RegisterResponseModel>> register(
    RegisterRequestModel request,
  ) async {
    try {
      final deviceId = await deviceInfoService.getDeviceId();
      final response = await loginApiService.register(
        request.copyWith(deviceId: deviceId),
      );
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }
}
