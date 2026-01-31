// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamModel _$ExamModelFromJson(Map<String, dynamic> json) => ExamModel(
  id: (json['id'] as num).toInt(),
  examTitle: json['exam_title'] as String,
  duration: json['duration'] as String,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExamModelToJson(ExamModel instance) => <String, dynamic>{
  'id': instance.id,
  'exam_title': instance.examTitle,
  'duration': instance.duration,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

ExamResponseModel _$ExamResponseModelFromJson(Map<String, dynamic> json) =>
    ExamResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: ExamModel.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'],
    );

Map<String, dynamic> _$ExamResponseModelToJson(ExamResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data.toJson(),
      'errors': instance.errors,
    };
