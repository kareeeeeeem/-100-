class ExamSubmissionModel {
  final int attemptId;
  final String score;
  final bool passed;

  ExamSubmissionModel({
    required this.attemptId,
    required this.score,
    required this.passed,
  });

  factory ExamSubmissionModel.fromJson(Map<String, dynamic> json) {
    return ExamSubmissionModel(
      attemptId: int.tryParse(json['attempt_id']?.toString() ?? '') ?? 0,
      score: json['score']?.toString() ?? '',
      passed: json['passed'] == true || json['passed']?.toString() == '1',
    );
  }

  Map<String, dynamic> toJson() => {
        'attempt_id': attemptId,
        'score': score,
        'passed': passed,
      };
}
