import 'package:get_it/get_it.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/live_sessions/data/data_sources/live_session_api_service.dart';
import 'package:lms/features/son_flow/live_sessions/data/repositories/live_session_repository_impl.dart';
import 'package:lms/features/son_flow/live_sessions/domain/repositories/live_session_repository.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_cubit.dart';

final sl = GetIt.instance;

class LiveSessionDi {
  Future<void> init() async {
    // 1. Register API Service
    sl.registerLazySingleton<LiveSessionApiService>(
      () => LiveSessionApiService(sl<ApiService>(), sl<JwtService>()),
    );

    // 2. Register Repository
    sl.registerLazySingleton<LiveSessionRepository>(
      () => LiveSessionRepositoryImpl(sl<LiveSessionApiService>()),
    );

    // 3. Register Cubit
    sl.registerFactory<LiveSessionCubit>(
      () => LiveSessionCubit(sl<LiveSessionRepository>()),
    );
  }
}
