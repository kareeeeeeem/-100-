import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/live_sessions/data/models/live_session_model.dart';

abstract class LiveSessionRepository {
  Future<Result<LiveSessionsDataModel>> getLiveSessions();
  Future<Result<LiveSessionsDataModel>> getSectionLiveSessions(String sectionId);
  Future<Result<JoinSessionDataModel>> joinSession(String sessionId);
}
