import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/exams/data/data_sources/exam_api_service.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_submission_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_result_model.dart';
import 'package:lms/features/son_flow/exams/domain/repositories/exam_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamApiService _apiService;

  ExamRepositoryImpl(this._apiService);

  @override
  Future<Result<List<ExamModel>>> getExams() async {
    try {
      final response = await _apiService.getExams();
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<List<ExamModel>>> getExamsBySection(String sectionId) async {
    try {
      final response = await _apiService.getExamsBySection(sectionId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<ExamModel>> getExam(String examId) async {
    try {
      final response = await _apiService.getExam(examId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<ExamSubmissionModel>> submitExam(
    String examId,
    Map<String, String> answers,
  ) async {
    try {
      final response = await _apiService.submitExam(examId, answers);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<ExamResultModel>> getExamResults(String attemptId) async {
    try {
      final response = await _apiService.getExamResults(attemptId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }
}
