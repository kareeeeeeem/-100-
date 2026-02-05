

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

class MyCoursesResponseModel {
  final bool status;
  final String message;
  final List<MyCourseItemModel> data;

  MyCoursesResponseModel({required this.status, required this.message, required this.data});

  factory MyCoursesResponseModel.fromJson(Map<String, dynamic> json) {
    return MyCoursesResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: (json['data'] is List)
          ? (json['data'] as List).map((e) => MyCourseItemModel.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class MyCourseItemModel {
  final dynamic id; 
  final String title;
  final String duration;
  final String category;
  
  final dynamic progressPercentage; // غيرها لـ dynamic
  
  final String? thumbnail;
  
  final dynamic lessonsCount; // غيرها لـ dynamic

  final dynamic totalLessonsCount;

  final bool isSubscribed;

  final InstructorModel instructor;
  final PricingInfo? pricing;
  final String? sections;

  MyCourseItemModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.category,
    this.progressPercentage,
    this.thumbnail,
    this.lessonsCount,
    this.totalLessonsCount,
    this.isSubscribed = false,
    required this.instructor,
    this.pricing,
    this.sections,
  });

  // دوال مساعدة عشان تحول القيم لنصوص بأمان في الـ UI
  String get progressText => progressPercentage?.toString() ?? "0";
  String get lessonsCountText => lessonsCount?.toString() ?? "0";

  factory MyCourseItemModel.fromJson(Map<String, dynamic> json) {
    return MyCourseItemModel(
      id: json['id'],
      title: (json['title']?.toString() ?? '').trim(),
      duration: (json['duration']?.toString() ?? '').trim(),
      category: (json['category']?.toString() ?? '').trim(),
      progressPercentage: json['progress_percentage'],
      thumbnail: (json['thumbnail']?.toString() ?? '').trim(),
      lessonsCount: json['lessons_count'],
      totalLessonsCount: json['total_lessons_count'],
      isSubscribed: json['is_subscribed'] == true,
      instructor: InstructorModel.fromJson(json['instructor'] ?? {}),
      pricing: json['pricing'] is Map<String, dynamic> ? PricingInfo.fromJson(json['pricing']) : null,
      sections: json['sections']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'duration': duration,
        'category': category,
        'progress_percentage': progressPercentage,
        'thumbnail': thumbnail,
        'lessons_count': lessonsCount,
        'total_lessons_count': totalLessonsCount,
        'is_subscribed': isSubscribed,
        'instructor': instructor.toJson(),
        'pricing': pricing?.toJson(),
        'sections': sections,
      };
}

class InstructorModel {
  final String name;
  final String? image;

  InstructorModel({required this.name, this.image});

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      name: (json['name']?.toString() ?? '').trim(),
      image: (json['image']?.toString() ?? '').trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
      };
}