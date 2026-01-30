import 'package:lms/core/di/app_di.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart'; // تأكد من إضافة هذا الـ import
import 'package:lms/features/on_boarding/presentation/manger/my_courses_cubit.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service_impl.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_cubit.dart';
import 'package:lms/features/son_flow/home/data/repository/home_repository_impl.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/home/presentation/manager/home_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/update_profile_cubit.dart';

class HomeDi extends AppDi {
  @override
  Future<void> init() async {
    // التعديل هنا: تمرير sl<JwtService>() للـ HomeApiServiceImpl
    sl.registerLazySingleton<HomeApiService>(
      () => HomeApiServiceImpl(sl<ApiService>(), sl<JwtService>()),
    );

    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(sl<HomeApiService>()),
    );
    
    sl.registerLazySingleton(() => HomeCubit(sl<HomeRepository>()));
    
    // تسجيل الكيوبيت الجديد
    sl.registerFactory(() => MyCoursesCubit(sl<HomeRepository>()));

    sl.registerFactory(() => ProfileCubit(sl<HomeRepository>()));

    // في ملف HomeDi.dart ضيف السطر ده تحت الـ Cubits التانية
sl.registerFactory(() => UpdateProfileCubit(sl<HomeRepository>()));

// ضيف ده جوه ميثود init() في ملف HomeDi
sl.registerFactory(() => CourseDetailsCubit(sl<HomeApiService>()));
  }
}