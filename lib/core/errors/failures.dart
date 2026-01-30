import 'package:lms/core/constants/app_constants.dart';
import 'package:lms/core/errors/api_error_type.dart';

sealed class Failure {
  final String message;

  const Failure({required this.message});
}

class CustomFailure extends Failure {
  CustomFailure({required super.message});
}

class ApiFailure extends Failure {
  final ApiErrorType apiErrorType;

  ApiFailure(this.apiErrorType, {required super.message});
}

class SlowInternetConnectionFailure extends Failure {
  SlowInternetConnectionFailure({
    super.message = AppConstants.thisTookSoLongPleaseTryAgain,
  });
}

class NoInternetConnectionFailure extends Failure {
  NoInternetConnectionFailure({
    super.message = AppConstants.noInternetConnection,
  });
}

class RequestCancelledFailure extends Failure {
  RequestCancelledFailure({super.message = AppConstants.requestWasCancelled});
}

class UnknownFailure extends Failure {
  UnknownFailure({String? message})
    : super(message: message ?? AppConstants.somethingWentWrong);
}
