import 'package:dio/dio.dart';

final class DioBuilder {
  final List<Interceptor> _interceptors = [];
  BaseOptions? _baseOptions;

  DioBuilder();

  DioBuilder addInterceptor(Interceptor interceptor) {
    _interceptors.add(interceptor);
    return this;
  }

  DioBuilder setBaseOptions(BaseOptions options) {
    _baseOptions = options;
    return this;
  }

  Dio build() {
    final dio = Dio(_baseOptions ?? BaseOptions())
      ..interceptors.addAll(_interceptors);
    return dio;
  }
}