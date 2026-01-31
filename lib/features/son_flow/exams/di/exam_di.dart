import 'package:get_it/get_it.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/exams/data/data_sources/exam_api_service.dart';
import 'package:lms/features/son_flow/exams/data/repositories/exam_repository_impl.dart';
import 'package:lms/features/son_flow/exams/domain/repositories/exam_repository.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';

final sl = GetIt.instance;

class ExamDi {
  Future<void> init() async {
    // 1. Register API Service
    sl.registerLazySingleton<ExamApiService>(
      () => ExamApiService(sl<ApiService>(), sl<JwtService>()),
    );

    // 2. Register Repository
    sl.registerLazySingleton<ExamRepository>(
      () => ExamRepositoryImpl(sl<ExamApiService>()),
    );

    // 3. Register Cubit
    sl.registerFactory<ExamCubit>(
      () => ExamCubit(sl<ExamRepository>()),
    );
  }
}
