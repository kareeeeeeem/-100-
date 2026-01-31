import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';

class ChildModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final Map<String, dynamic>? stats;
  final List<MyCourseItemModel>? courses;

  ChildModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.stats,
    this.courses,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'],
      name: (json['name']?.toString() ?? '').trim(),
      email: (json['email']?.toString() ?? '').trim(),
      phone: (json['phone']?.toString())?.trim(),
      avatar: (json['avatar']?.toString())?.trim(),
      stats: json['stats'],
      courses: json['courses'] != null
          ? (json['courses'] as List).map((e) => MyCourseItemModel.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'stats': stats,
      'courses': courses?.map((e) => e.toJson()).toList(),
    };
  }
}
