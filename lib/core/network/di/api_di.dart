import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/di/app_di.dart';
import 'package:lms/core/network/dio/dio_builder.dart';
import 'package:lms/core/network/interceptors/auth_interceptor.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/network/service/dio_api_service.dart';
import 'package:lms/core/service/cache_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/core/service/jwt_service_impl.dart';
import 'package:lms/core/utils/custom_dio_logger.dart';

class ApiDi extends AppDi {
  @override
  Future<void> init() async {
    sl.registerLazySingleton<JwtService>(
      () => JwtServiceServiceImpl(
        sl<CacheService>(instanceName: 'SecureCacheService'),
      ),
    );
    Dio dio = _buildAppDio();
    sl.registerLazySingleton(() => dio);
    sl.registerLazySingleton<ApiService>(() => DioApiService(sl<Dio>()));
  }

  Dio _buildAppDio() {
    final dioBuilder = DioBuilder()
        .setBaseOptions(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout: ApiConstants.sendTimeout,
            responseType: ResponseType.json,
            receiveDataWhenStatusError: true,
            followRedirects: true,
          ),
        )
        .addInterceptor(AuthInterceptor(sl<JwtService>()));
    // .addInterceptor(LocalizationInterceptor(sl<LocaleProvider>()))

    if (kDebugMode) {
      dioBuilder.addInterceptor(CustomPrettyDioLogger());
    }

    return dioBuilder.build();
  }
}
