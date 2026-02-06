class QuestionModel {
  final String id;
  final String questionText;
  final String? questionImage;
  final String? difficulty;
  final String type; // mcq or whiteboard
  final String options; // comma-separated string like "Figma,Photoshop,Sketch"
  final dynamic rawOptions; // New field to hold the raw structure

  QuestionModel({
    required this.id,
    required this.questionText,
    this.questionImage,
    this.difficulty,
    required this.type,
    required this.options,
    this.rawOptions,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id']?.toString() ?? '',
      questionText: json['question_text']?.toString() ?? '',
      questionImage: json['question_image']?.toString(),
      difficulty: json['difficulty']?.toString(),
      type: json['type']?.toString() ?? 'mcq',
      options: json['options']?.toString() ?? '',
      rawOptions: json['options'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'question_text': questionText,
        'question_image': questionImage,
        'difficulty': difficulty,
        'type': type,
        'options': options,
      };

  // Helper to parse options into a list
  List<dynamic> get optionsList {
    if (rawOptions != null && rawOptions is List) {
      return rawOptions as List;
    }
    // Fallback for comma-separated strings
    if (options.isNotEmpty) {
       return options.split(',').map((e) => e.trim()).toList();
    }
    return [];
  }

  bool get isMultipleChoice => type.toLowerCase() == 'mcq';
  bool get isWhiteboard => type.toLowerCase() == 'whiteboard';
}
