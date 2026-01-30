import 'package:lms/core/constants/app_constants.dart';

class CustomException implements Exception {
  final String message;

  CustomException({String? errorMessage})
    : message = errorMessage ?? AppConstants.somethingWentWrong;
}
