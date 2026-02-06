import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/routing/app_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/core/utils/custom_dio_logger.dart';

class AuthInterceptor extends Interceptor {
  final JwtService jwtService;

  AuthInterceptor(this.jwtService);

  Completer<void>? _refreshTokenCompleter;
@override
void onRequest(
  RequestOptions options,
  RequestInterceptorHandler handler,
) async {
  final accessToken = await jwtService.getAccessToken();

  // لو التوكن موجود، ضيفه في كل الحالات أو لو الطلب محتاج auth
  if (accessToken != null && accessToken.isNotEmpty) {
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
  }
  
  // تأكد دائماً من وجود الـ Accept header
  options.headers['Accept'] = 'application/json';
  
  handler.next(options);
}

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final dio = _getNewDio(GetIt.instance<Dio>());

    final isAuthError = err.response?.statusCode == HttpStatus.unauthorized;
    
    // التعديل هنا أيضاً ليتوافق مع نفس المنطق في onError
    final isPublicEndPoint = !err.requestOptions.headers.containsKey(
      ApiConstants.requiresAuthKey,
    );

    if (!isAuthError || isPublicEndPoint) {
      return handler.next(err);
    }

    if (_refreshTokenCompleter != null) {
      try {
        await _refreshTokenCompleter!.future;

        final newAccessToken = await jwtService.getAccessToken();
        final headers = Map<String, dynamic>.from(err.requestOptions.headers);
        headers[HttpHeaders.authorizationHeader] = 'Bearer $newAccessToken';

        final newRequest = err.requestOptions.copyWith(headers: headers);
        final newResponse = await dio.fetch(newRequest);
        return handler.resolve(newResponse);
      } catch (e) {
        return handler.reject(err);
      }
    }

    _refreshTokenCompleter = Completer();
    try {
      final accessToken = await jwtService.getAccessToken();
      final refreshToken = await jwtService.getRefreshToken();
      final refreshTokenResponse = await dio.post(
        ApiConstants.authRefreshToken,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
        ),
        data: {'refreshToken': refreshToken},
      );

      if (refreshTokenResponse.statusCode == HttpStatus.ok) {
        final newAccessToken = refreshTokenResponse.data['data']['accessToken'];
        final newRefreshToken =
            refreshTokenResponse.data['data']['refreshToken'];

        await Future.wait([
          jwtService.saveAccessToken(newAccessToken),
          jwtService.saveRefreshToken(newRefreshToken),
        ]);

        _refreshTokenCompleter?.complete(); 
        _refreshTokenCompleter = null;

        final headersWithNewAccessToken = err.requestOptions.headers;
        headersWithNewAccessToken[HttpHeaders.authorizationHeader] =
            'Bearer $newAccessToken';

        final newRequestOptions = err.requestOptions.copyWith(
          headers: headersWithNewAccessToken,
        );
        final newResponse = await dio.fetch(newRequestOptions);
        return handler.resolve(newResponse);
      } else {
        return handler.reject(err);
      }
    } catch (e) {
      await Future.wait([
        jwtService.deleteAccessToken(),
        jwtService.deleteRefreshToken(),
      ]);
      AppRouter.navigatorKey.currentContext!.go(AppRoutes.login);
      return handler.reject(err);
    }
  }

  Dio _getNewDio(Dio dio) {
    final Dio newDio = dio.clone(interceptors: Interceptors());
    if (kDebugMode) {
      newDio.interceptors.addAll([CustomPrettyDioLogger()]);
    }
    return newDio;
  }
}