import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/live_sessions/domain/repositories/live_session_repository.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_state.dart';
import 'package:lms/features/son_flow/live_sessions/data/models/live_session_model.dart';

class LiveSessionCubit extends Cubit<LiveSessionState> {
  final LiveSessionRepository _repository;

  LiveSessionCubit(this._repository) : super(LiveSessionInitial());

  Future<void> loadLiveSessions() async {
    emit(LiveSessionLoading());
    final result = await _repository.getLiveSessions();

    if (result.isSuccess) {
      emit(LiveSessionsLoaded(result.data!));
    } else {
      emit(LiveSessionError(result.failure?.message ?? 'Unknown Error'));
    }
  }

  Future<void> joinSession(String sessionId) async {
    LiveSessionsDataModel? currentSessions;
    if (state is LiveSessionsLoaded) {
      currentSessions = (state as LiveSessionsLoaded).sessions;
    } else if (state is LiveSessionJoining) {
      currentSessions = (state as LiveSessionJoining).currentSessions;
    } else if (state is LiveSessionJoined) {
      currentSessions = (state as LiveSessionJoined).currentSessions;
    }

    emit(LiveSessionJoining(currentSessions: currentSessions));
    final result = await _repository.joinSession(sessionId);

    if (result.isSuccess) {
      emit(LiveSessionJoined(result.data!, currentSessions: currentSessions));
    } else {
      emit(LiveSessionError(result.failure?.message ?? 'Unknown Error'));
    }
  }
}
