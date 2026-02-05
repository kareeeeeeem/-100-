import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/live_sessions/data/data_sources/live_session_api_service.dart';
import 'package:lms/features/son_flow/live_sessions/data/models/live_session_model.dart';
import 'package:lms/features/son_flow/live_sessions/domain/repositories/live_session_repository.dart';

class LiveSessionRepositoryImpl implements LiveSessionRepository {
  final LiveSessionApiService _apiService;

  LiveSessionRepositoryImpl(this._apiService);

  @override
  Future<Result<LiveSessionsDataModel>> getLiveSessions() async {
    try {
      final response = await _apiService.getLiveSessions();
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<LiveSessionsDataModel>> getSectionLiveSessions(String sectionId) async {
    try {
      final response = await _apiService.getSectionLiveSessions(sectionId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<JoinSessionDataModel>> joinSession(String sessionId) async {
    try {
      final response = await _apiService.joinSession(sessionId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }
}
