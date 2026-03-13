import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';

class LessonsResponseModel {
  final bool? status;
  final String? message;
  final List<Lesson>? data;
  final dynamic errors;
  final String? studentIdentityNumber; // ضيف السطر ده

  LessonsResponseModel({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.studentIdentityNumber,
  });

  factory LessonsResponseModel.fromJson(Map<String, dynamic> json) {
    List<Lesson>? lessons;
    if (json['data'] is List) {
      lessons = (json['data'] as List)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return LessonsResponseModel(
      status: json['status'],
      message: json['message']?.toString(),
      data: lessons,
      errors: json['errors'],
      studentIdentityNumber: json['student_identity_number']?.toString(), // ضيف السطر ده
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
        'errors': errors,
        'student_identity_number': studentIdentityNumber, // ضيف السطر ده
      };
}
