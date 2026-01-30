import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lms/core/enums/request_status_enum.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(RequestStatus.initial) RequestStatus registerStatus,
    String? registerErrorMessage,
  }) = _RegisterState;

  // السطرين دول هيحلوا مشكلة الـ Missing implementation للأبد
  const RegisterState._();
  
  @override
  RequestStatus get registerStatus => throw UnimplementedError();
  @override
  String? get registerErrorMessage => throw UnimplementedError();
}