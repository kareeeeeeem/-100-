import 'package:json_annotation/json_annotation.dart';

part 'exam_result_model.g.dart';

@JsonSerializable()
class ExamResultModel {
  final String id;
  final String score;
  final String status; // ناجح / راسب
  
  @JsonKey(name: 'total_questions')
  final String totalQuestions;
  
  final String answers; // JSON string or details

  ExamResultModel({
    required this.id,
    required this.score,
    required this.status,
    required this.totalQuestions,
    required this.answers,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) =>
      _$ExamResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResultModelToJson(this);
  
  bool get isPassed => status.contains('ناجح');
}

@JsonSerializable()
class ExamResultResponseModel {
  final bool status;
  final String message;
  final ExamResultModel data;
  final dynamic errors;

  ExamResultResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory ExamResultResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExamResultResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResultResponseModelToJson(this);
}
