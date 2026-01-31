import 'package:json_annotation/json_annotation.dart';

part 'live_session_model.g.dart';

@JsonSerializable()
class LiveSessionStatsModel {
  @JsonKey(name: 'date_human')
  final String dateHuman;

  LiveSessionStatsModel({
    required this.dateHuman,
  });

  factory LiveSessionStatsModel.fromJson(Map<String, dynamic> json) =>
      _$LiveSessionStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiveSessionStatsModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LiveSessionModel {
  final String id;
  final String title;
  
  @JsonKey(name: 'course_name')
  final String courseName;
  
  final String? thumbnail;
  
  @JsonKey(name: 'scheduled_at')
  final String scheduledAt;
  
  @JsonKey(name: 'is_archived')
  final bool isArchived;
  
  @JsonKey(name: 'is_live')
  final bool isLive; // Changed from String to bool
  
  @JsonKey(name: 'recorded_url')
  final String? recordedUrl;
  
  final LiveSessionStatsModel stats;

  LiveSessionModel({
    required this.id,
    required this.title,
    required this.courseName,
    this.thumbnail,
    required this.scheduledAt,
    required this.isArchived,
    required this.isLive,
    this.recordedUrl,
    required this.stats,
  });

  factory LiveSessionModel.fromJson(Map<String, dynamic> json) {
    return LiveSessionModel(
      id: (json['id']?.toString() ?? '').trim(),
      title: (json['title']?.toString() ?? '').trim(),
      courseName: (json['course_name']?.toString() ?? '').trim(),
      thumbnail: (json['thumbnail']?.toString())?.trim(),
      scheduledAt: (json['scheduled_at']?.toString() ?? '').trim(),
      isArchived: json['is_archived'] ?? false,
      isLive: json['is_live'] ?? false, // Parsing as bool directly
      recordedUrl: (json['recorded_url']?.toString())?.trim(),
      stats: LiveSessionStatsModel.fromJson(json['stats'] ?? {'date_human': ''}),
    );
  }

  Map<String, dynamic> toJson() => _$LiveSessionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LiveSessionsResponseModel {
  final bool status;
  final String message;
  final LiveSessionsDataModel data;
  final dynamic errors;

  LiveSessionsResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory LiveSessionsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LiveSessionsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiveSessionsResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LiveSessionsDataModel {
  @JsonKey(name: 'available_now')
  final List<LiveSessionModel> availableNow;
  
  final List<LiveSessionModel> archived;

  LiveSessionsDataModel({
    required this.availableNow,
    required this.archived,
  });

  factory LiveSessionsDataModel.fromJson(Map<String, dynamic> json) =>
      _$LiveSessionsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiveSessionsDataModelToJson(this);
}

@JsonSerializable()
class JoinSessionResponseModel {
  final bool status;
  final String message;
  final JoinSessionDataModel data;
  final dynamic errors;

  JoinSessionResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory JoinSessionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$JoinSessionResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$JoinSessionResponseModelToJson(this);
}

@JsonSerializable()
class JoinSessionDataModel {
  @JsonKey(name: 'session_id')
  final String sessionId;
  
  @JsonKey(name: 'join_url')
  final String joinUrl;

  JoinSessionDataModel({
    required this.sessionId,
    required this.joinUrl,
  });

  factory JoinSessionDataModel.fromJson(Map<String, dynamic> json) =>
      _$JoinSessionDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$JoinSessionDataModelToJson(this);
}
