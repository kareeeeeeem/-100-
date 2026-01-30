import 'package:lms/core/di/app_di.dart';
import 'package:lms/core/service/cache_service.dart';
import 'package:lms/features/on_boarding/data/data_sources/on_boarding_cache_service.dart';
import 'package:lms/features/on_boarding/data/data_sources/on_boarding_cache_service_impl.dart';
import 'package:lms/features/on_boarding/data/repository/on_boarding_repository_impl.dart';
import 'package:lms/features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'package:lms/features/on_boarding/presentation/manger/on_boarding_cubit.dart';

class OnBoardingDi extends AppDi {
  @override
  Future<void> init() async {
    sl.registerLazySingleton<OnBoardingCacheService>(
      () => OnBoardingCacheServiceImpl(
        sl<CacheService>(instanceName: 'SharedPrefsCacheService'),
      ),
    );

    sl.registerLazySingleton<OnBoardingRepository>(
      () => OnBoardingRepositoryImpl(sl<OnBoardingCacheService>()),
    );

    sl.registerLazySingleton(() => OnBoardingCubit(sl<OnBoardingRepository>()));
  }
}
