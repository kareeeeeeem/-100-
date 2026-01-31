import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_submission_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_result_model.dart';

abstract class ExamRepository {
  Future<Result<List<ExamModel>>> getExams();
  Future<Result<ExamModel>> getExam(String examId);
  
  Future<Result<ExamSubmissionModel>> submitExam(
    String examId,
    Map<String, String> answers,
  );
  
  Future<Result<ExamResultModel>> getExamResults(String attemptId);
}
