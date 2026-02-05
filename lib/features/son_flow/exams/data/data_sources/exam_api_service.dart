import 'package:flutter/foundation.dart';
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
      ApiConstants.examsList,
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final dynamic rawData = response is List ? response : (response['data'] ?? []);
    List<dynamic> list = [];
    if (rawData is List) {
      list = rawData;
    } else if (rawData is Map && rawData['data'] is List) {
      list = rawData['data'];
    } else if (rawData is Map && rawData['exams'] is List) {
      list = rawData['exams'];
    }

    return list.map((e) => ExamModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ExamModel>> getExamsBySection(String sectionId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.sectionExams(sectionId),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final dynamic rawData = response is List ? response : (response['data'] ?? []);
    List<dynamic> list = [];
    if (rawData is List) {
      list = rawData;
    } else if (rawData is Map && rawData['data'] is List) {
      list = rawData['data'];
    } else if (rawData is Map && rawData['exams'] is List) {
      list = rawData['exams'];
    }

    return list.map((e) => ExamModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ExamModel> getExam(String examId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.examDetails(examId),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = ExamResponseModel.fromJson(response);
    return ExamModel.fromJson(responseModel.data is Map ? responseModel.data : {});
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
    
    final responseModel = ExamResponseModel.fromJson(response);
    return ExamSubmissionModel.fromJson(responseModel.data is Map ? responseModel.data : {});
  }

  Future<ExamResultModel> getExamResults(String attemptId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.examResults(attemptId),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final responseModel = ExamResponseModel.fromJson(response);
    return ExamResultModel.fromJson(responseModel.data is Map ? responseModel.data : {});
  }
}
