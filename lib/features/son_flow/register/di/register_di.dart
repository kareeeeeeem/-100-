import 'package:lms/core/di/app_di.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/device_info_service.dart';
import 'package:lms/features/son_flow/register/data/data_sources/api/register_api_service.dart';
import 'package:lms/features/son_flow/register/data/data_sources/api/register_api_service_impl.dart';
import 'package:lms/features/son_flow/register/data/repository/register_repository_impl.dart';
import 'package:lms/features/son_flow/register/domain/repository/register_repository.dart';
import 'package:lms/features/son_flow/register/presentation/manager/register_cubit.dart';

class RegisterDi extends AppDi {
  @override
  Future<void> init() async {
    sl.registerLazySingleton<RegisterApiService>(
      () => RegisterApiServiceImpl(sl<ApiService>()),
    );
    sl.registerLazySingleton<RegisterRepository>(
      () => RegisterRepositoryImpl(
        sl<RegisterApiService>(),
        sl<DeviceInfoService>(),
      ),
    );
    sl.registerLazySingleton(() => RegisterCubit(sl<RegisterRepository>()));
  }
}
