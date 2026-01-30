import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/features/son_flow/register/data/data_sources/api/register_api_service.dart';
import 'package:lms/features/son_flow/register/data/model/register_request_model.dart';
import 'package:lms/features/son_flow/register/data/model/register_response_model.dart';

class RegisterApiServiceImpl implements RegisterApiService {
  final ApiService apiService;

  RegisterApiServiceImpl(this.apiService);

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    final response = await apiService.post(
      ApiConstants.register,
      body: request.toJson(),
    );
    return RegisterResponseModel.fromJson(response);
  }
}
