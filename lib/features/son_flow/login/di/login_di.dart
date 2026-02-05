import 'package:device_info_plus/device_info_plus.dart';
import 'package:lms/core/di/app_di.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/device_info_service.dart';
import 'package:lms/core/service/device_info_service_impl.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/login/data/data_sources/api/login_api_service.dart';
import 'package:lms/features/son_flow/login/data/data_sources/api/login_api_service_impl.dart';
import 'package:lms/features/son_flow/login/data/repository/login_repository_impl.dart';
import 'package:lms/features/son_flow/login/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/login/presentation/manager/login_cubit.dart';
import 'package:lms/features/son_flow/login/presentation/manager/forgot_password_cubit.dart';
import 'package:lms/core/service/firebase_auth_service.dart';

class LoginDi extends AppDi {
  @override
  Future<void> init() async {
    sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
    
    sl.registerLazySingleton<DeviceInfoService>(
      () => DeviceInfoServiceImpl(DeviceInfoPlugin()),
    );
    sl.registerLazySingleton<LoginApiService>(
      () => LoginApiServiceImpl(sl<ApiService>()),
    );
    sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(
        sl<LoginApiService>(),
        sl<DeviceInfoService>(),
        sl<JwtService>(),
      ),
    );
    sl.registerFactory(() => LoginCubit(sl<LoginRepository>(), sl<FirebaseAuthService>()));
    sl.registerFactory(() => ForgotPasswordCubit(sl<LoginApiService>()));
  }
}
