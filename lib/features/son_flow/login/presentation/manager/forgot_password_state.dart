import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState.initial() = _Initial;
  const factory ForgotPasswordState.loading() = _Loading;
  
  // Step 1: Identifier sent, phone received
  const factory ForgotPasswordState.sentOtpSuccess(String phone, String message) = _SentOtpSuccess;
  
  // Step 2: OTP verified
  const factory ForgotPasswordState.verifyOtpSuccess(String message) = _VerifyOtpSuccess;
  
  // Step 3: Password reset success
  const factory ForgotPasswordState.resetPasswordSuccess(String message) = _ResetPasswordSuccess;
  
  const factory ForgotPasswordState.error(String message) = _Error;
}
