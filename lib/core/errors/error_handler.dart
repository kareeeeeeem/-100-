import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/constants/app_constants.dart';
import 'package:lms/core/errors/api_error_type.dart';
import 'package:lms/core/errors/custom_exception.dart';
import 'package:lms/core/errors/failures.dart';

class ErrorHandler {
  static Failure getFailure(
    dynamic exception, {
    String Function(DioException exception)? extractor,
  }) {
    if (exception is DioException) {
      return _handleDioError(exception, extractor: extractor);
    } else if (exception is CustomException) {
      return CustomFailure(message: exception.message);
    }
    return UnknownFailure(message: exception?.toString());
  }

  static Failure _handleDioError(
    DioException error, {
    String Function(DioException exception)? extractor,
  }) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => SlowInternetConnectionFailure(),
      DioExceptionType.connectionError => NoInternetConnectionFailure(),
      DioExceptionType.badResponse => _getFailureFromStatusCode(
        error,
        extractor: extractor,
      ),
      DioExceptionType.cancel => RequestCancelledFailure(),
      _ => UnknownFailure(),
    };
  }

  static Failure _getFailureFromStatusCode(
    DioException exception, {
    String Function(DioException exception)? extractor,
  }) {
    final code = exception.response?.statusCode;
    final type =
        ApiErrorType.values.firstWhereOrNull((e) => e.statusCode == code) ??
        ApiErrorType.other;

    return ApiFailure(
      type,
      message: extractor?.call(exception) ?? _extractMessage(exception),
    );
  }

  static String _extractMessage(DioException e) {
    final dynamic data = e.response?.data;

    return switch (data) {
      final String message => message,
      {'errors': Map errors} => _extractErrors(errors),
      {'message': final String message} => message,
      _ => AppConstants.somethingWentWrong,
    };
  }

  static String _extractErrors(Map errors) {
    final List<String> allMessages = [];

    for (var fieldErrors in errors.values) {
      if (fieldErrors is List && fieldErrors.isNotEmpty) {
        allMessages.add(fieldErrors.first.toString());
      } else if (fieldErrors is String) {
        allMessages.add(fieldErrors);
      }
    }

    return allMessages.isNotEmpty
        ? allMessages.join('\n')
        : AppConstants.somethingWentWrong;
  }
}
