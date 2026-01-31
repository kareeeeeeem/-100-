import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/exams/domain/repositories/exam_repository.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamRepository _repository;

  ExamCubit(this._repository) : super(ExamInitial());

  Future<void> loadExams() async {
    emit(ExamLoading());
    final result = await _repository.getExams();

    if (result.isSuccess) {
      emit(ExamsLoaded(result.data!));
    } else {
      emit(ExamError(result.failure?.message ?? 'Unknown Error'));
    }
  }

  Future<void> loadExam(String examId) async {
    emit(ExamLoading());
    final result = await _repository.getExam(examId);

    if (result.isSuccess) {
      emit(ExamLoaded(result.data!));
    } else {
      emit(ExamError(result.failure?.message ?? 'Unknown Error'));
    }
  }

  Future<void> submitExam(String examId, Map<String, String> answers) async {
    emit(ExamSubmitting());
    final result = await _repository.submitExam(examId, answers);

    if (result.isSuccess) {
      emit(ExamSubmitted(result.data!));
    } else {
      emit(ExamError(result.failure?.message ?? 'Unknown Error'));
    }
  }

  Future<void> loadExamResults(String attemptId) async {
    emit(ExamResultsLoading());
    final result = await _repository.getExamResults(attemptId);

    if (result.isSuccess) {
      emit(ExamResultsLoaded(result.data!));
    } else {
      emit(ExamError(result.failure?.message ?? 'Unknown Error'));
    }
  }
}
