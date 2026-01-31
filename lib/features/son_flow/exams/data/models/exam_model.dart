import 'package:json_annotation/json_annotation.dart';
import 'package:lms/features/son_flow/exams/data/models/question_model.dart';

part 'exam_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExamModel {
  final int id;
  @JsonKey(name: 'exam_title')
  final String examTitle;
  
  String get title => examTitle;

  final String duration;
  final List<QuestionModel> questions;

  ExamModel({
    required this.id,
    required this.examTitle,
    required this.duration,
    required this.questions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) =>
      _$ExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ExamResponseModel {
  final bool status;
  final String message;
  final ExamModel data;
  final dynamic errors;

  ExamResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory ExamResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExamResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResponseModelToJson(this);
}
