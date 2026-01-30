import 'package:get_it/get_it.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart'; // ضيف الـ import ده
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service_impl.dart';
import 'package:lms/features/son_flow/home/data/repository/home_repository_impl.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/home/presentation/manager/home_cubit.dart';
import 'package:lms/features/on_boarding/presentation/manger/my_courses_cubit.dart';

class HomeDi {
  final sl = GetIt.instance;

  Future<void> init() async {
    // التصليح هنا: مررنا sl() مرتين، الأولى للـ ApiService والتانية للـ JwtService
    sl.registerLazySingleton<HomeApiService>(
      () => HomeApiServiceImpl(sl<ApiService>(), sl<JwtService>()),
    );

    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(sl<HomeApiService>()),
    );

    sl.registerFactory(() => HomeCubit(sl<HomeRepository>()));
    
    // تسجيل كيوبيت الكورسات بالمرة عشان يشتغل معاك
    sl.registerFactory(() => MyCoursesCubit(sl<HomeRepository>()));
  }
}