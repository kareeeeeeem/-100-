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
  final bool isFavorited;
  final bool isSubscribed; // Added isSubscribed
  final String? progressPercentage; // Added progressPercentage
  final dynamic lessonsCount; // Added lessonsCount

  CourseData({
    this.id, this.title, this.description, this.thumbnail, 
    this.duration, this.category, this.instructor, this.price, this.lessons,
    this.isFavorited = false,
    this.isSubscribed = false,
    this.progressPercentage,
    this.lessonsCount,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    final dynamic rawId = json['id'] ?? json['course_id'];
    
    // Handle lessons more robustly (Map vs List)
    List<Lesson>? lessonsList;
    if (json['lessons'] is List) {
      lessonsList = (json['lessons'] as List).map((e) => Lesson.fromJson(e)).toList();
    } else if (json['lessons'] is Map && json['lessons']['data'] is List) {
      lessonsList = (json['lessons']['data'] as List).map((e) => Lesson.fromJson(e)).toList();
    }

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
      lessons: lessonsList,
      isFavorited: json['is_favorited'] ?? false,
      isSubscribed: json['is_subscribed'] ?? false,
      progressPercentage: json['progress_percentage']?.toString(),
      lessonsCount: json['lessons_count'],
    );
  }
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
        image: (json['image']?.toString())?.trim(),
        bio: (json['bio']?.toString())?.trim(),
        stats: json['stats'] is Map<String, dynamic> ? InstructorStats.fromJson(json['stats']) : null,
      );
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