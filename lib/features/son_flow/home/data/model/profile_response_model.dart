import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';

class ProfileResponseModel {
  final bool? status;
  final String? message;
  final ProfileData? data;

  ProfileResponseModel({this.status, this.message, this.data});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) => ProfileResponseModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
      );
}

class ProfileData {
  final String? name;
  final String? email;
  final String? image;
  final int? enrolledCoursesCount;
  final int? completedCoursesCount;
  final int? certificatesCount;
  final double? overallProgress;
  // أضفنا الحقل ده عشان الـ UI ميدي ش أيرور
  final List<MyCourseItemModel>? recentCourses; 

  ProfileData({
    this.name,
    this.email,
    this.image,
    this.enrolledCoursesCount,
    this.completedCoursesCount,
    this.certificatesCount,
    this.overallProgress,
    this.recentCourses,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        name: json['name'] ?? json['user']?['name'],
        email: json['email'] ?? json['user']?['email'],
        image: json['image'] ?? json['user']?['image'],
        enrolledCoursesCount: json['enrolled_courses_count'],
        completedCoursesCount: json['completed_courses_count'],
        certificatesCount: json['certificates_count'],
        overallProgress: (json['overall_progress'] as num?)?.toDouble(),
        // هنا بنحول لستة الكورسات اللي جاية من الـ API
        recentCourses: (json['recent_courses'] as List?)
            ?.map((e) => MyCourseItemModel.fromJson(e))
            .toList(),
      );
}