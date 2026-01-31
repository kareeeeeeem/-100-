import 'package:get_it/get_it.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/parent_flow/data/data_sources/parent_api_service.dart';
import 'package:lms/features/parent_flow/data/repositories/parent_repository_impl.dart';
import 'package:lms/features/parent_flow/domain/repositories/parent_repository.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_cubit.dart';

class ParentDi {
  final GetIt sl = GetIt.instance;

  Future<void> init() async {
    // 1. Register API Service
    sl.registerLazySingleton<ParentApiService>(
      () => ParentApiService(sl<ApiService>(), sl<JwtService>()),
    );

    // 2. Register Repository
    sl.registerLazySingleton<ParentRepository>(
      () => ParentRepositoryImpl(sl<ParentApiService>()),
    );

    // 3. Register Cubits
    sl.registerFactory(() => ParentCubit(sl<ParentRepository>()));
  }
}
