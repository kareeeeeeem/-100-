import 'package:lms/core/errors/failures.dart';

final class Result<T> {
  final T? data;

  final Failure? failure;

  const Result.success(this.data) : failure = null;

  const Result.error(this.failure) : data = null;

  bool get isSuccess => data != null;

  bool get isError => failure != null;

  void fold(Function(T data) onSuccess, Function(Failure failure) onError) {
    if (isSuccess) {
      onSuccess(data as T);
    } else {
      onError(failure!);
    }
  }
}

class NoOutput {
  const NoOutput();
}
