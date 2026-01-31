import 'package:get_it/get_it.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/instructor_profile/data/data_sources/instructor_api_service.dart';
import 'package:lms/features/son_flow/instructor_profile/data/repositories/instructor_repository_impl.dart';
import 'package:lms/features/son_flow/instructor_profile/domain/repositories/instructor_repository.dart';
import 'package:lms/features/son_flow/instructor_profile/presentation/manager/instructor_cubit.dart';

final sl = GetIt.instance;

class InstructorDi {
  Future<void> init() async {
    // 1. Register API Service
    sl.registerLazySingleton<InstructorApiService>(
      () => InstructorApiService(sl<ApiService>(), sl<JwtService>()),
    );

    // 2. Register Repository
    sl.registerLazySingleton<InstructorRepository>(
      () => InstructorRepositoryImpl(sl<InstructorApiService>()),
    );

    // 3. Register Cubit
    sl.registerFactory<InstructorCubit>(
      () => InstructorCubit(sl<InstructorRepository>()),
    );
  }
}
