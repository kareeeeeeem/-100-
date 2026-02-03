class InstructorResponseModel {
  bool? status;
  String? message;
  InstructorData? data;

  InstructorResponseModel({this.status, this.message, this.data});

  InstructorResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? InstructorData.fromJson(json['data']) : null;
  }
}

class InstructorData {
  dynamic id; // استخدم dynamic لأن الـ API قد يرسله string أو int
  String? name;
  String? avatar;
  String? bio;
  InstructorStats? stats;
  List<dynamic>? assistants;
  List<RelatedCourse>? relatedCourses;

  InstructorData({this.id, this.name, this.avatar, this.bio, this.stats, this.assistants, this.relatedCourses});

  InstructorData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString(); // تحويل آمن لأي نوع داتا جاي من الـ ID
    name = json['name'];
    avatar = json['avatar'];
    bio = json['bio'];
    stats = json['stats'] != null ? InstructorStats.fromJson(json['stats']) : null;
    if (json['related_courses'] != null) {
      relatedCourses = <RelatedCourse>[];
      json['related_courses'].forEach((v) {
        relatedCourses!.add(RelatedCourse.fromJson(v));
      });
    }
  }
}

class InstructorStats {
  String? experience;
  String? students;
  String? courses;

  InstructorStats({this.experience, this.students, this.courses});

  InstructorStats.fromJson(Map<String, dynamic> json) {
    experience = json['experience'];
    students = json['students'];
    courses = json['courses'];
  }
}

class RelatedCourse {
  dynamic id;
  String? title;
  String? thumbnail;
  // أضف أي حقول أخرى تحتاجها من الـ API

  RelatedCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbnail = json['thumbnail'];
  }
}