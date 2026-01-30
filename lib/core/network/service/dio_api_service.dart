import 'package:dio/dio.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class DioApiService implements ApiService {
  final Dio dio;

  DioApiService(this.dio);

  @override
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.get(
      url,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.post(
      url,
      data: body,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> upload(
    String url, {
    required String filePath,
    required String context,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final fileName = basename(filePath);
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: DioMediaType.parse(mimeType),
      ),
      'context': context,
    });

    final response = await dio.post(
      url,
      data: formData,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.put(
      url,
      data: body,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.patch(
      url,
      data: body,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.delete(
      url,
      data: body,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );

    return response.data;
  }
}
