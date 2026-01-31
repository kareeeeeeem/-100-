class CourseDetailsResponseModel {
  final bool status;
  final String message;
  final CourseData? data;

  CourseDetailsResponseModel({required this.status, required this.message, this.data});

  factory CourseDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CourseData.fromJson(json['data']) : null,
    );
  }
}

class CourseData {
  final String id;
  final String title;
  final String duration;
  final String category;
  final String? thumbnail;
  final List<Lesson>? lessons; // أضفت قائمة الدروس لتتوافق مع الـ UI
  final Instructor instructor;
  final Price price;

  CourseData({
    required this.id,
    required this.title,
    required this.duration,
    required this.category,
    this.thumbnail,
    this.lessons,
    required this.instructor,
    required this.price,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      category: json['category'] ?? '',
      thumbnail: json['thumbnail'],
      lessons: json['lessons'] != null 
          ? (json['lessons'] as List).map((i) => Lesson.fromJson(i)).toList() 
          : [],
      instructor: Instructor.fromJson(json['instructor'] ?? {}),
      price: Price.fromJson(json['price'] ?? {}),
    );
  }
}

class Lesson {
  final String? title;
  final String? duration;
  final String? videoUrl;

  Lesson({this.title, this.duration, this.videoUrl});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title'],
      duration: json['duration'],
      videoUrl: json['video_url'],
    );
  }
}

class Instructor {
  final String name;
  final String? image;

  Instructor({required this.name, this.image});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      name: json['name'] ?? '',
      image: json['image'],
    );
  }
}

class Price {
  final String value;
  final bool isFree;
  final String label;

  Price({required this.value, required this.isFree, required this.label});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      value: json['value']?.toString() ?? '0',
      isFree: json['is_free'] ?? false,
      label: json['label'] ?? '',
    );
  }
}