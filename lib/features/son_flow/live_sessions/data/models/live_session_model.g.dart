// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveSessionStatsModel _$LiveSessionStatsModelFromJson(
  Map<String, dynamic> json,
) => LiveSessionStatsModel(dateHuman: json['date_human'] as String);

Map<String, dynamic> _$LiveSessionStatsModelToJson(
  LiveSessionStatsModel instance,
) => <String, dynamic>{'date_human': instance.dateHuman};

LiveSessionModel _$LiveSessionModelFromJson(Map<String, dynamic> json) =>
    LiveSessionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      courseName: json['course_name'] as String,
      thumbnail: json['thumbnail'] as String?,
      scheduledAt: json['scheduled_at'] as String,
      isArchived: json['is_archived'] as bool,
      isLive: json['is_live'],
      liveUrl: json['live_url'] as String?,
      recordedUrl: json['recorded_url'] as String?,
      stats: LiveSessionStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$LiveSessionModelToJson(LiveSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'course_name': instance.courseName,
      'thumbnail': instance.thumbnail,
      'scheduled_at': instance.scheduledAt,
      'is_archived': instance.isArchived,
      'is_live': instance.isLive,
      'live_url': instance.liveUrl,
      'recorded_url': instance.recordedUrl,
      'stats': instance.stats.toJson(),
    };

LiveSessionsResponseModel _$LiveSessionsResponseModelFromJson(
  Map<String, dynamic> json,
) => LiveSessionsResponseModel(
  status: json['status'] as bool,
  message: json['message'] as String,
  data: LiveSessionsDataModel.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'],
);

Map<String, dynamic> _$LiveSessionsResponseModelToJson(
  LiveSessionsResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data.toJson(),
  'errors': instance.errors,
};

LiveSessionsDataModel _$LiveSessionsDataModelFromJson(
  Map<String, dynamic> json,
) => LiveSessionsDataModel(
  availableNow: (json['available_now'] as List<dynamic>)
      .map((e) => LiveSessionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  archived: (json['archived'] as List<dynamic>)
      .map((e) => LiveSessionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LiveSessionsDataModelToJson(
  LiveSessionsDataModel instance,
) => <String, dynamic>{
  'available_now': instance.availableNow.map((e) => e.toJson()).toList(),
  'archived': instance.archived.map((e) => e.toJson()).toList(),
};

JoinSessionResponseModel _$JoinSessionResponseModelFromJson(
  Map<String, dynamic> json,
) => JoinSessionResponseModel(
  status: json['status'] as bool,
  message: json['message'] as String,
  data: JoinSessionDataModel.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'],
);

Map<String, dynamic> _$JoinSessionResponseModelToJson(
  JoinSessionResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
};

JoinSessionDataModel _$JoinSessionDataModelFromJson(
  Map<String, dynamic> json,
) => JoinSessionDataModel(
  sessionId: json['session_id'] as String,
  joinUrl: json['join_url'] as String,
);

Map<String, dynamic> _$JoinSessionDataModelToJson(
  JoinSessionDataModel instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'join_url': instance.joinUrl,
};
