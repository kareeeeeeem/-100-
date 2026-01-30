class CourseDetailsResponseModel {
  final bool? status;
  final String? message;
  final CourseData? data;

  CourseDetailsResponseModel({this.status, this.message, this.data});

  factory CourseDetailsResponseModel.fromJson(Map<String, dynamic> json) => CourseDetailsResponseModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? CourseData.fromJson(json['data']) : null,
      );
}

class CourseData {
  final int? id;
  final String? title;
  final String? description;
  final List<Lesson>? lessons;

  CourseData({this.id, this.title, this.description, this.lessons});

  factory CourseData.fromJson(Map<String, dynamic> json) => CourseData(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        lessons: (json['lessons'] as List?)?.map((e) => Lesson.fromJson(e)).toList(),
      );
}

class Lesson {
  final int? id;
  final String? title;
  final String? videoUrl; 
  final String? duration;

  Lesson({this.id, this.title, this.videoUrl, this.duration});

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        title: json['title'],
        videoUrl: json['video_url'], 
        duration: json['duration'],
      );
}