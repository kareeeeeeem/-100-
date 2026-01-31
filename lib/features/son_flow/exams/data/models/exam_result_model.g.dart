// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamResultModel _$ExamResultModelFromJson(Map<String, dynamic> json) =>
    ExamResultModel(
      id: json['id'] as String,
      score: json['score'] as String,
      status: json['status'] as String,
      totalQuestions: json['total_questions'] as String,
      answers: json['answers'] as String,
    );

Map<String, dynamic> _$ExamResultModelToJson(ExamResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'status': instance.status,
      'total_questions': instance.totalQuestions,
      'answers': instance.answers,
    };

ExamResultResponseModel _$ExamResultResponseModelFromJson(
  Map<String, dynamic> json,
) => ExamResultResponseModel(
  status: json['status'] as bool,
  message: json['message'] as String,
  data: ExamResultModel.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'],
);

Map<String, dynamic> _$ExamResultResponseModelToJson(
  ExamResultResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
};
