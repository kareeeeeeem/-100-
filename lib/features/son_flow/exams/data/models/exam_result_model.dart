class ExamResultModel {
  final String id;
  final String score;
  final String status; // ناجح / راسب
  final String totalQuestions;
  final String answers; // JSON string or details

  ExamResultModel({
    required this.id,
    required this.score,
    required this.status,
    required this.totalQuestions,
    required this.answers,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      id: json['id']?.toString() ?? '',
      score: json['score']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalQuestions: json['total_questions']?.toString() ?? '',
      answers: json['answers']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'score': score,
        'status': status,
        'total_questions': totalQuestions,
        'answers': answers,
      };

  bool get isPassed => status.contains('ناجح');
}
