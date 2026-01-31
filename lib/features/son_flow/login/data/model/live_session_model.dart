class LiveSessionModel {
  final bool status;
  final String message;
  final LiveSessionData data;

  LiveSessionModel({required this.status, required this.message, required this.data});

  factory LiveSessionModel.fromJson(Map<String, dynamic> json) => LiveSessionModel(
        status: json['status'],
        message: json['message'],
        data: LiveSessionData.fromJson(json['data']),
      );
}

class LiveSessionData {
  final List<LiveSessionResource> availableNow;
  final List<LiveSessionResource> archived;

  LiveSessionData({required this.availableNow, required this.archived});

  factory LiveSessionData.fromJson(Map<String, dynamic> json) => LiveSessionData(
        availableNow: (json['available_now'] as List)
            .map((x) => LiveSessionResource.fromJson(x))
            .toList(),
        archived: (json['archived'] as List)
            .map((x) => LiveSessionResource.fromJson(x))
            .toList(),
      );
}
class LiveSessionResource {
  final String id;
  final String title;
  final String courseName;
  final String? thumbnail;
  final String scheduledAt;
  final bool isArchived;

  LiveSessionResource({
    required this.id,
    required this.title,
    required this.courseName,
    this.thumbnail,
    required this.scheduledAt,
    required this.isArchived,
  });

  factory LiveSessionResource.fromJson(Map<String, dynamic> json) => LiveSessionResource(
        id: (json['id']?.toString() ?? '').trim(),
        title: (json['title']?.toString() ?? '').trim(),
        courseName: (json['course_name']?.toString() ?? '').trim(),
        thumbnail: (json['thumbnail']?.toString())?.trim(),
        scheduledAt: (json['scheduled_at']?.toString() ?? '').trim(),
        // تعديل مهم: التأكد من تحويل القيمة لـ bool مهما كان نوعها من السيرفر
        isArchived: json['is_archived'] == true || json['is_archived'] == 1 || json['is_archived'] == "1",
      );
}