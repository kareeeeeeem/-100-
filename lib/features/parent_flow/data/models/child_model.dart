import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';

class ChildModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? identityNumber;
  final String? avatar;
  final Map<String, dynamic>? stats;
  final List<MyCourseItemModel>? courses;

  ChildModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.identityNumber,
    this.avatar,
    this.stats,
    this.courses,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    try {
      return ChildModel(
        id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
        name: (json['name']?.toString() ?? '').trim(),
        email: (json['email']?.toString() ?? '').trim(),
        phone: (json['phone']?.toString())?.trim(),
        identityNumber: (json['identity_number']?.toString())?.trim(),
        avatar: (json['avatar']?.toString())?.trim(),
        stats: (json['stats'] is Map) ? Map<String, dynamic>.from(json['stats']) : null,
        courses: (json['courses'] is List)
            ? (json['courses'] as List).map((e) => MyCourseItemModel.fromJson(e)).toList()
            : [],
      );
    } catch (e) {
      print('❌ Error parsing ChildModel: $e');
      print('   Data: $json');
      // Return a basic model instead of crashing
      return ChildModel(
        id: 0,
        name: 'خطأ في التحميل',
        email: '',
      );
    }
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
