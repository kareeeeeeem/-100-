import 'package:get_it/get_it.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/dashboard/data/data_sources/dashboard_api_service.dart';
import 'package:lms/features/son_flow/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:lms/features/son_flow/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:lms/features/son_flow/dashboard/presentation/manager/dashboard_cubit.dart';

final sl = GetIt.instance;

class DashboardDi {
  Future<void> init() async {
    // 1. Register API Service
    sl.registerLazySingleton<DashboardApiService>(
      () => DashboardApiService(sl<ApiService>(), sl<JwtService>()),
    );

    // 2. Register Repository
    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(sl<DashboardApiService>()),
    );

    // 3. Register Cubit
    sl.registerFactory<DashboardCubit>(
      () => DashboardCubit(sl<DashboardRepository>()),
    );
  }
}
