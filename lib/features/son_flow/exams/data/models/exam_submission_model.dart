import 'package:json_annotation/json_annotation.dart';

part 'exam_submission_model.g.dart';

@JsonSerializable()
class ExamSubmissionModel {
  @JsonKey(name: 'attempt_id')
  final int attemptId;
  
  final String score;
  final bool passed;

  ExamSubmissionModel({
    required this.attemptId,
    required this.score,
    required this.passed,
  });

  factory ExamSubmissionModel.fromJson(Map<String, dynamic> json) =>
      _$ExamSubmissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSubmissionModelToJson(this);
}

@JsonSerializable()
class ExamSubmissionResponseModel {
  final bool status;
  final String message;
  final ExamSubmissionModel data;
  final dynamic errors;

  ExamSubmissionResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory ExamSubmissionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExamSubmissionResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSubmissionResponseModelToJson(this);
}
