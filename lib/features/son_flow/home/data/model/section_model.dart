import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_model.dart';

class SectionModel {
  final int id;
  final String title;
  final List<Lesson>? lessons;
  final List<ExamModel>? exams;

  SectionModel({
    required this.id,
    required this.title,
    this.lessons,
    this.exams,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    List<T> parseList<T>(dynamic jsonKey, T Function(Map<String, dynamic>) fromJson) {
      if (jsonKey is List) {
        return jsonKey.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      } else if (jsonKey is Map && jsonKey['data'] is List) {
        return (jsonKey['data'] as List).map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    }

    return SectionModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      lessons: parseList<Lesson>(json['lessons'], Lesson.fromJson),
      exams: parseList<ExamModel>(json['exams'], ExamModel.fromJson),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'lessons': lessons?.map((e) => e.toJson()).toList(),
        'exams': exams?.map((e) => e.toJson()).toList(),
      };
}
