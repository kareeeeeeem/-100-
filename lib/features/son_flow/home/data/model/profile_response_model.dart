import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/dashboard/data/models/dashboard_stats_model.dart';


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
  final String? phone;
  final String? image;
  final String? identityNumber;
  final String? userType;
  final int? enrolledCoursesCount;
  final int? completedCoursesCount;
  final int? certificatesCount;
  final double? overallProgress;
  // أضفنا الحقل ده عشان الـ UI ميدي ش أيرور
  final List<MyCourseItemModel>? recentCourses; 
  final DashboardStatsModel? dashboardStats;

  ProfileData({
    this.name,
    this.email,
    this.phone,
    this.image,
    this.identityNumber,
    this.userType,
    this.enrolledCoursesCount,
    this.completedCoursesCount,
    this.certificatesCount,
    this.overallProgress,
    this.recentCourses,
    this.dashboardStats,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    
    return ProfileData(
      name: (json['name']?.toString() ?? userJson?['name']?.toString() ?? '').trim(),
      email: (json['email']?.toString() ?? userJson?['email']?.toString() ?? '').trim(),
      phone: (json['phone']?.toString() ?? userJson?['phone']?.toString() ?? '').trim(),
      image: (json['image']?.toString() ?? userJson?['image']?.toString() ?? '').trim(),
      identityNumber: (json['identity_number']?.toString() ?? userJson?['identity_number']?.toString() ?? '').trim(),
      userType: (json['user_type_text']?.toString() ?? userJson?['user_type_text']?.toString() ?? '').trim(),
      enrolledCoursesCount: json['enrolled_courses_count'],
      completedCoursesCount: json['completed_courses_count'],
      certificatesCount: json['certificates_count'],
      overallProgress: (json['overall_progress'] as num?)?.toDouble(),
      recentCourses: (json['recent_courses'] as List?)
          ?.map((e) => MyCourseItemModel.fromJson(e))
          .toList(),
    );
  }
}