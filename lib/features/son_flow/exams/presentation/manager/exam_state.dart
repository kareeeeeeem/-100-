import 'package:lms/features/son_flow/exams/data/models/exam_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_submission_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_result_model.dart';

abstract class ExamState {}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamsLoaded extends ExamState {
  final List<ExamModel> exams;

  ExamsLoaded(this.exams);
}

class ExamLoaded extends ExamState {
  final ExamModel exam;

  ExamLoaded(this.exam);
}

class ExamSubmitting extends ExamState {}

class ExamSubmitted extends ExamState {
  final ExamSubmissionModel submission;

  ExamSubmitted(this.submission);
}

class ExamResultsLoading extends ExamState {}

class ExamResultsLoaded extends ExamState {
  final ExamResultModel results;

  ExamResultsLoaded(this.results);
}

class ExamError extends ExamState {
  final String message;

  ExamError(this.message);
}
