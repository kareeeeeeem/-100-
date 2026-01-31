import 'package:json_annotation/json_annotation.dart';

part 'question_model.g.dart';

@JsonSerializable()
class QuestionModel {
  final String id;
  
  @JsonKey(name: 'question_text')
  final String questionText;
  
  final String type; // mcq or whiteboard
  final String options; // comma-separated string like "Figma,Photoshop,Sketch"

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.type,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
  
  // Helper to parse options into a list
  List<String> get optionsList {
    if (options.isEmpty) return [];
    return options.split(',').map((e) => e.trim()).toList();
  }
  
  bool get isMultipleChoice => type.toLowerCase() == 'mcq';
  bool get isWhiteboard => type.toLowerCase() == 'whiteboard';
}
