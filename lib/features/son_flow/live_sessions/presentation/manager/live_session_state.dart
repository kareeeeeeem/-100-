import 'package:lms/features/son_flow/live_sessions/data/models/live_session_model.dart';

abstract class LiveSessionState {}

class LiveSessionInitial extends LiveSessionState {}

class LiveSessionLoading extends LiveSessionState {}

class LiveSessionsLoaded extends LiveSessionState {
  final LiveSessionsDataModel sessions;

  LiveSessionsLoaded(this.sessions);
}

class LiveSessionJoining extends LiveSessionState {}

class LiveSessionJoined extends LiveSessionState {
  final JoinSessionDataModel joinData;

  LiveSessionJoined(this.joinData);
  
  String get joinUrl => joinData.joinUrl;
}

class LiveSessionError extends LiveSessionState {
  final String message;

  LiveSessionError(this.message);
}
