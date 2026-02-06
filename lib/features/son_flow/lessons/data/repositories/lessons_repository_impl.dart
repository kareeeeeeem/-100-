import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/lessons/data/data_sources/lessons_api_service.dart';
import 'package:lms/features/son_flow/lessons/domain/repositories/lessons_repository.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  final LessonsApiService _apiService;

  LessonsRepositoryImpl(this._apiService);

  @override
  Future<Result<List<Lesson>>> getSectionLessons(String sectionId) async {
    try {
      final response = await _apiService.getSectionLessons(sectionId);
      return Result.success(response.data ?? []);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }
}
