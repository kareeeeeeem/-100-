import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/register/data/model/register_request_model.dart';
import 'package:lms/features/son_flow/register/data/model/register_response_model.dart';

abstract class RegisterRepository {
  Future<Result<RegisterResponseModel>> register(RegisterRequestModel request);
}
