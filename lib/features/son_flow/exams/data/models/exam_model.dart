import 'package:lms/features/son_flow/exams/data/models/question_model.dart';

class ExamModel {
  final int id;
  final String title;
  final String? duration;
  final int? durationMinutes;
  final int? passingScore;
  final int? questionsCount;
  final bool? isCompleted;
  final List<QuestionModel>? questions;

  ExamModel({
    required this.id,
    required this.title,
    this.duration,
    this.durationMinutes,
    this.passingScore,
    this.questionsCount,
    this.isCompleted,
    this.questions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: (json['title'] ?? json['exam_title'] ?? '').toString(),
      duration: json['duration']?.toString(),
      durationMinutes: int.tryParse(json['duration_minutes']?.toString() ?? ''),
      passingScore: int.tryParse(json['passing_score']?.toString() ?? ''),
      questionsCount: int.tryParse(json['questions_count']?.toString() ?? ''),
      isCompleted: json['is_completed'] == true || json['is_completed']?.toString() == '1',
      questions: (json['questions'] is List)
          ? (json['questions'] as List).map((e) => QuestionModel.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'duration': duration,
        'duration_minutes': durationMinutes,
        'passing_score': passingScore,
        'questions_count': questionsCount,
        'is_completed': isCompleted,
        'questions': questions?.map((e) => e.toJson()).toList(),
      };
}

class ExamResponseModel {
  final bool status;
  final String message;
  final dynamic data;
  final dynamic errors;

  ExamResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory ExamResponseModel.fromJson(Map<String, dynamic> json) {
    return ExamResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'],
      errors: json['errors'],
    );
  }
}
