import 'package:get_it/get_it.dart';
import 'package:lms/features/son_flow/lessons/data/data_sources/lessons_api_service.dart';
import 'package:lms/features/son_flow/lessons/data/repositories/lessons_repository_impl.dart';
import 'package:lms/features/son_flow/lessons/domain/repositories/lessons_repository.dart';
import 'package:lms/features/son_flow/lessons/presentation/manager/lessons_cubit.dart';

class LessonsDi {
  static void init(GetIt sl) {
    // API Service
    sl.registerLazySingleton<LessonsApiService>(
      () => LessonsApiServiceImpl(sl(), sl()),
    );

    // Repository
    sl.registerLazySingleton<LessonsRepository>(
      () => LessonsRepositoryImpl(sl()),
    );

    // Cubit
    sl.registerFactory(() => LessonsCubit(sl()));
  }
}
