// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_submission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamSubmissionModel _$ExamSubmissionModelFromJson(Map<String, dynamic> json) =>
    ExamSubmissionModel(
      attemptId: (json['attempt_id'] as num).toInt(),
      score: json['score'] as String,
      passed: json['passed'] as bool,
    );

Map<String, dynamic> _$ExamSubmissionModelToJson(
  ExamSubmissionModel instance,
) => <String, dynamic>{
  'attempt_id': instance.attemptId,
  'score': instance.score,
  'passed': instance.passed,
};

ExamSubmissionResponseModel _$ExamSubmissionResponseModelFromJson(
  Map<String, dynamic> json,
) => ExamSubmissionResponseModel(
  status: json['status'] as bool,
  message: json['message'] as String,
  data: ExamSubmissionModel.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'],
);

Map<String, dynamic> _$ExamSubmissionResponseModelToJson(
  ExamSubmissionResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
};
