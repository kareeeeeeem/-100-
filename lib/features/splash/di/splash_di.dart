import 'package:lms/core/di/app_di.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'package:lms/features/splash/data/repository/splash_repository_impl.dart';
import 'package:lms/features/splash/domain/repository/splash_repository.dart';
import 'package:lms/features/splash/presentation/manager/splash_cubit.dart';

class SplashDi extends AppDi {
  @override
  Future<void> init() async {
    sl.registerLazySingleton<SplashRepository>(
      () => SplashRepositoryImpl(sl<JwtService>()),
    );

    sl.registerLazySingleton(
      () => SplashCubit(sl<OnBoardingRepository>(), sl<SplashRepository>()),
    );
  }
}
