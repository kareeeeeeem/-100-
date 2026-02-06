import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/core/network/di/api_di.dart';
import 'package:lms/core/service/cache_service.dart';
import 'package:lms/core/service/secure_cache_service.dart';
import 'package:lms/core/service/shared_prefs_cache_service.dart';
import 'package:lms/core/service/toast_service.dart';
import 'package:lms/core/service/toast_service_impl.dart';
import 'package:lms/features/localization/di/localization_di.dart';
import 'package:lms/features/on_boarding/di/on_boarding_di.dart';
import 'package:lms/features/son_flow/course/presentation/pages/WishlistCubit.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/live_sessions_api_service.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/home/presentation/manager/notifications_cubit.dart';
import 'package:lms/features/son_flow/login/di/login_di.dart';
import 'package:lms/features/son_flow/register/di/register_di.dart';
import 'package:lms/features/splash/di/splash_di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms/features/son_flow/home/di/home_di.dart';
import 'package:lms/features/parent_flow/di/parent_di.dart';
import 'package:lms/features/son_flow/instructor_profile/di/instructor_di.dart';
import 'package:lms/features/son_flow/dashboard/di/dashboard_di.dart';
import 'package:lms/features/son_flow/exams/di/exam_di.dart';
import 'package:lms/features/son_flow/live_sessions/di/live_session_di.dart';
import 'package:lms/features/son_flow/pdfs/di/pdfs_di.dart';
import 'package:lms/features/son_flow/lessons/di/lessons_di.dart';
import 'package:lms/features/son_flow/community/di/community_di.dart';

class AppDi {
  final GetIt sl = GetIt.instance;

  Future<void> init() async {
    sl.allowReassignment = true;

    // 1. أولاً: سجل الـ SharedPreferences والـ SecureStorage
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => const FlutterSecureStorage());

    // 2. ثانياً: سجل خدمات الكاش (مهم جداً قبل أي شيء آخر)
    sl.registerLazySingleton<CacheService>(
      () => SharedPrefsCacheService(sl()),
      instanceName: 'SharedPrefsCacheService',
    );

    sl.registerLazySingleton<CacheService>(
      () => SecureCacheService(sl()),
      instanceName: 'SecureCacheService',
    );

    sl.registerLazySingleton<ToastService>(() => ToastServiceImpl());

    // 3. ثالثاً: الآن استدعِ الـ Modules التي تعتمد على الكاش
    await LocaleDi().init(); // الـ LocaleDi الآن سيجد SharedPrefsCacheService جاهزاً
    await ApiDi().init();
    await OnBoardingDi().init();

    // 4. أخيراً: بقية الـ Features
    await SplashDi().init();
    await LoginDi().init();
    await RegisterDi().init();
    await HomeDi().init();
    await ParentDi().init();
    await InstructorDi().init();
    await DashboardDi().init();
    await ExamDi().init();
    await LiveSessionDi().init();
    await PDFsDi.init();
    LessonsDi.init(sl);
    await CommunityDi().init();

    // تسجيل الـ NotificationsCubit بعد التأكد من تسجيل الـ HomeRepository
    sl.registerFactory(() => NotificationsCubit(sl<HomeRepository>()));

    sl.registerLazySingleton(() => LiveSessionsApiService(sl()));

    sl.registerLazySingleton(() => WishlistCubit(sl<CacheService>(instanceName: 'SharedPrefsCacheService')));
  }
}
