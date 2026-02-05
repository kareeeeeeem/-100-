class QuestionModel {
  final String id;
  final String questionText;
  final String type; // mcq or whiteboard
  final String options; // comma-separated string like "Figma,Photoshop,Sketch"

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.type,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id']?.toString() ?? '',
      questionText: json['question_text']?.toString() ?? '',
      type: json['type']?.toString() ?? 'mcq',
      options: json['options']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'question_text': questionText,
        'type': type,
        'options': options,
      };

  // Helper to parse options into a list
  List<String> get optionsList {
    if (options.isEmpty) return [];
    return options.split(',').map((e) => e.trim()).toList();
  }

  bool get isMultipleChoice => type.toLowerCase() == 'mcq';
  bool get isWhiteboard => type.toLowerCase() == 'whiteboard';
}
