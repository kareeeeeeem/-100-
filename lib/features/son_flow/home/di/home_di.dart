import 'package:lms/core/di/app_di.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/on_boarding/presentation/manger/my_courses_cubit.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service_impl.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_cubit.dart';
import 'package:lms/features/son_flow/home/data/repository/home_repository_impl.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/home/presentation/manager/home_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/categories_cubit.dart';
import 'package:lms/features/son_flow/profile/presentation/manager/change_password_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/payment_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/search_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/update_profile_cubit.dart';
import 'package:lms/features/son_flow/dashboard/domain/repositories/dashboard_repository.dart';

class HomeDi extends AppDi {
  @override
  Future<void> init() async {
    sl.registerLazySingleton<HomeApiService>(
      () => HomeApiServiceImpl(sl<ApiService>(), sl<JwtService>()),
    );

    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(sl<HomeApiService>()),
    );
    
    sl.registerLazySingleton(() => HomeCubit(sl<HomeRepository>()));
    
    sl.registerFactory(() => MyCoursesCubit(sl<HomeRepository>()));

    sl.registerLazySingleton(() => ProfileCubit(sl<HomeRepository>(), sl<DashboardRepository>(), sl<JwtService>()));

    sl.registerFactory(() => UpdateProfileCubit(sl<HomeRepository>()));

    sl.registerFactory(() => CourseDetailsCubit(sl<HomeRepository>()));
    sl.registerFactory(() => ChangePasswordCubit(sl<HomeRepository>()));  
    sl.registerFactory(() => CategoriesCubit(sl<HomeRepository>()));
    sl.registerFactory(() => SearchCubit(sl<HomeRepository>()));
    sl.registerFactory(() => PaymentCubit(sl<HomeRepository>()));
  }
}