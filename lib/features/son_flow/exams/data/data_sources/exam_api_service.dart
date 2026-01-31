import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_submission_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_result_model.dart';

class ExamApiService {
  final ApiService _apiService;
  final JwtService _jwtService;

  ExamApiService(this._apiService, this._jwtService);

  Future<List<ExamModel>> getExams() async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.exams,
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final List<dynamic> data = response is List ? response : (response['data'] ?? []);
    return data.map((e) => ExamModel.fromJson(e)).toList();
  }

  Future<ExamModel> getExam(String examId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.examDetails(examId),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = ExamResponseModel.fromJson(response);
    return responseModel.data;
  }

  Future<ExamSubmissionModel> submitExam(
    String examId,
    Map<String, String> answers,
  ) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.post(
      ApiConstants.submitExam(examId),
      body: {'answers': answers},
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = ExamSubmissionResponseModel.fromJson(response);
    return responseModel.data;
  }

  Future<ExamResultModel> getExamResults(String attemptId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.examResults(attemptId),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = ExamResultResponseModel.fromJson(response);
    return responseModel.data;
  }
}
