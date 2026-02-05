import 'package:flutter/foundation.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_model.dart';
import 'package:lms/features/son_flow/home/data/model/section_model.dart';

class CourseDetailsResponseModel {
  final bool? status;
  final String? message;
  final CourseData? data;

  CourseDetailsResponseModel({this.status, this.message, this.data});

  factory CourseDetailsResponseModel.fromJson(Map<String, dynamic> json) => CourseDetailsResponseModel(
        status: json['status'],
        message: json['message']?.toString(),
        data: json['data'] is Map<String, dynamic> ? CourseData.fromJson(json['data']) : null,
      );
}

class CourseData {
  final dynamic id;
  final String? title;
  final String? description;
  final String? thumbnail; // الصورة
  final String? duration;   // مدة الكورس الإجمالية
  final String? category;   // القسم
  final Instructor? instructor; // بيانات المدرس
  final PriceInfo? price;       // السعر
  final List<Lesson>? lessons;
  final List<ExamModel>? exams; // Added exams
  final bool isFavorited;
  final bool isSubscribed;
  final String? progressPercentage;
  final dynamic lessonsCount;
  final dynamic totalLessonsCount; // Added totalLessonsCount
  final PricingInfo? pricing; // Added detailed pricing
  final List<SectionModel>? sections; // Updated to List<SectionModel>

  CourseData({
    this.id, this.title, this.description, this.thumbnail, 
    this.duration, this.category, this.instructor, this.price, this.lessons,
    this.exams,
    this.isFavorited = false,
    this.isSubscribed = false,
    this.progressPercentage,
    this.lessonsCount,
    this.totalLessonsCount,
    this.pricing,
    this.sections,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    final dynamic rawId = json['id'] ?? json['course_id'];

    // Generic parser for lists that might be wrapped in 'data' or a Map
    List<T> parseList<T>(dynamic jsonKey, T Function(Map<String, dynamic>) fromJson) {
      if (jsonKey is List) {
        return jsonKey.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      } else if (jsonKey is Map && jsonKey['data'] is List) {
        return (jsonKey['data'] as List).map((e) => fromJson(e as Map<String, dynamic>)).toList();
      } else if (jsonKey is Map) {
        try {
          return (jsonKey as Map).values
              .whereType<Map<String, dynamic>>()
              .map((e) => fromJson(e))
              .toList();
        } catch (e) {
          debugPrint('❌ Error parsing Map to List: $e');
        }
      }
      return [];
    }

    final lessons = parseList<Lesson>(json['lessons'], Lesson.fromJson);
    final exams = parseList<ExamModel>(json['exams'], ExamModel.fromJson);
    final sections = parseList<SectionModel>(json['sections'], SectionModel.fromJson);

    return CourseData(
      id: rawId,
      title: (json['title']?.toString())?.trim(),
      description: (json['description']?.toString())?.trim(),
      thumbnail: (json['thumbnail']?.toString())?.trim(),
      duration: json['duration'] is Map 
          ? (json['duration']['value'] ?? '').toString().trim() 
          : (json['duration']?.toString())?.trim(),
      category: (json['category']?.toString())?.trim(),
      instructor: json['instructor'] is Map<String, dynamic> ? Instructor.fromJson(json['instructor']) : null,
      price: json['price'] is Map<String, dynamic> ? PriceInfo.fromJson(json['price']) : null,
      lessons: lessons,
      exams: exams,
      isFavorited: json['is_favorited'] == true || json['is_favorited']?.toString() == '1',
      isSubscribed: json['is_subscribed'] == true || json['is_subscribed']?.toString() == '1' || json['is_subscribed']?.toString() == 'true',
      progressPercentage: json['progress_percentage']?.toString(),
      lessonsCount: json['lessons_count'],
      totalLessonsCount: json['total_lessons_count'],
      pricing: json['pricing'] is Map<String, dynamic> ? PricingInfo.fromJson(json['pricing']) : null,
      sections: sections,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'thumbnail': thumbnail,
        'duration': duration,
        'category': category,
        'instructor': instructor?.toJson(),
        'price': price?.toJson(),
        'lessons': lessons?.map((e) => e.toJson()).toList(),
        'exams': exams?.map((e) => e.toJson()).toList(),
        'is_favorited': isFavorited,
        'is_subscribed': isSubscribed,
        'progress_percentage': progressPercentage,
        'lessons_count': lessonsCount,
        'total_lessons_count': totalLessonsCount,
        'pricing': pricing?.toJson(),
        'sections': sections?.map((e) => e.toJson()).toList(),
      };
}

class Instructor {
  final String? id;
  final String? name;
  final String? image;
  final String? bio;
  final InstructorStats? stats;

  Instructor({this.id, this.name, this.image, this.bio, this.stats});

  factory Instructor.fromJson(Map<String, dynamic> json) => Instructor(
        id: json['id']?.toString(),
        name: (json['name']?.toString())?.trim(),
        image: (json['image']?.toString() ?? json['avatar']?.toString())?.trim(),
        bio: (json['bio']?.toString())?.trim(),
        stats: json['stats'] is Map<String, dynamic> ? InstructorStats.fromJson(json['stats']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'bio': bio,
        'stats': stats?.toJson(),
      };
}

class InstructorStats {
  final String? experience;
  final String? students;
  final String? courses;

  InstructorStats({this.experience, this.students, this.courses});

  factory InstructorStats.fromJson(Map<String, dynamic> json) => InstructorStats(
    experience: json['experience']?.toString(),
    students: json['students']?.toString(),
    courses: json['courses']?.toString(),
  );

  Map<String, dynamic> toJson() => {
        'experience': experience,
        'students': students,
        'courses': courses,
      };
}

class PricingInfo {
  final dynamic originalPrice;
  final dynamic discountPrice;
  final dynamic hasDiscount;
  final dynamic currentPrice;
  final String? currency;
  final bool? isFree;
  final String? label;
  final String? discountPercentage;

  PricingInfo({
    this.originalPrice,
    this.discountPrice,
    this.hasDiscount,
    this.currentPrice,
    this.currency,
    this.isFree,
    this.label,
    this.discountPercentage,
  });

  factory PricingInfo.fromJson(Map<String, dynamic> json) => PricingInfo(
        originalPrice: json['original_price'],
        discountPrice: json['discount_price'],
        hasDiscount: json['has_discount'],
        currentPrice: json['current_price'],
        currency: json['currency'],
        isFree: json['is_free'],
        label: json['label'],
        discountPercentage: json['discount_percentage']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'original_price': originalPrice,
        'discount_price': discountPrice,
        'has_discount': hasDiscount,
        'current_price': currentPrice,
        'currency': currency,
        'is_free': isFree,
        'label': label,
        'discount_percentage': discountPercentage,
      };
}

class PriceInfo {
  final String? value;
  final String? label;
  final bool? isFree;

  PriceInfo({this.value, this.label, this.isFree});

  factory PriceInfo.fromJson(Map<String, dynamic> json) => PriceInfo(
        value: json['value']?.toString(),
        label: json['label'] is Map ? json['label']['value']?.toString() : json['label']?.toString(),
        isFree: json['is_free'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'label': label,
        'is_free': isFree,
      };
}

class Lesson {
  final int? id;
  final String? title;
  final String? videoUrl;
  final String? duration;

  Lesson({this.id, this.title, this.videoUrl, this.duration});

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: int.tryParse(json['id']?.toString() ?? ''),
        title: json['title']?.toString(),
        videoUrl: json['video_url']?.toString(),
        duration: json['duration']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'video_url': videoUrl,
        'duration': duration,
      };
}