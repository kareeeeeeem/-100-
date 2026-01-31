import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/instructor_profile/data/data_sources/instructor_api_service.dart';
import 'package:lms/features/son_flow/instructor_profile/data/models/instructor_profile_model.dart';
import 'package:lms/features/son_flow/instructor_profile/domain/repositories/instructor_repository.dart';

class InstructorRepositoryImpl implements InstructorRepository {
  final InstructorApiService _apiService;

  InstructorRepositoryImpl(this._apiService);

  @override
  Future<Result<InstructorProfileModel>> getInstructorProfile(
      String instructorId) async {
    try {
      final response = await _apiService.getInstructorProfile(instructorId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }
}
