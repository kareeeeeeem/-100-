import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lms/core/enums/request_status_enum.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    RequestStatus? loginStatus,
    String? loginErrorMessage,
    String? userType, // ضيف السطر ده هنا
  }) = _LoginState;
}
