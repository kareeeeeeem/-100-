class CourseDetailsResponseModel {
  final bool? status;
  final String? message;
  final CourseData? data;

  CourseDetailsResponseModel({this.status, this.message, this.data});

  factory CourseDetailsResponseModel.fromJson(Map<String, dynamic> json) => CourseDetailsResponseModel(
        status: json['status'],
        message: json['message']?.toString(),
        data: json['data'] != null ? CourseData.fromJson(json['data']) : null,
      );
}

class CourseData {
  final int? id;
  final String? title;
  final String? description;
  final String? thumbnail; // الصورة
  final String? duration;   // مدة الكورس الإجمالية
  final String? category;   // القسم
  final Instructor? instructor; // بيانات المدرس
  final PriceInfo? price;       // السعر
  final List<Lesson>? lessons;
  final bool isFavorited;

  CourseData({
    this.id, this.title, this.description, this.thumbnail, 
    this.duration, this.category, this.instructor, this.price, this.lessons,
    this.isFavorited = false,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) => CourseData(
        id: int.tryParse(json['id']?.toString() ?? ''),
        title: (json['title']?.toString())?.trim(),
        description: (json['description']?.toString())?.trim(),
        thumbnail: (json['thumbnail']?.toString())?.trim(),
        duration: (json['duration']?.toString())?.trim(),
        category: (json['category']?.toString())?.trim(),
        instructor: json['instructor'] != null ? Instructor.fromJson(json['instructor']) : null,
        price: json['price'] != null ? PriceInfo.fromJson(json['price']) : null,
        lessons: (json['lessons'] as List?)?.map((e) => Lesson.fromJson(e)).toList(),
        isFavorited: json['is_favorited'] ?? false,
      );
}

class Instructor {
  final String? name;
  final String? image;
  final String? bio;

  Instructor({this.name, this.image, this.bio});

  factory Instructor.fromJson(Map<String, dynamic> json) => Instructor(
        name: (json['name']?.toString())?.trim(),
        image: (json['image']?.toString())?.trim(),
        bio: (json['bio']?.toString())?.trim(),
      );
}

class PriceInfo {
  final String? value;
  final String? label;
  final bool? isFree;

  PriceInfo({this.value, this.label, this.isFree});

  factory PriceInfo.fromJson(Map<String, dynamic> json) => PriceInfo(
        value: json['value']?.toString(),
        label: json['label']?.toString(),
        isFree: json['is_free'] ?? false,
      );
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
}