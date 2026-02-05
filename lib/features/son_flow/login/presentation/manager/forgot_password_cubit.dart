import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/login/data/data_sources/api/login_api_service.dart';
import 'package:lms/features/son_flow/login/data/model/forgot_password_models.dart';
import 'package:lms/core/errors/error_handler.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final LoginApiService loginApiService;

  ForgotPasswordCubit(this.loginApiService) : super(const ForgotPasswordState.initial());

  Future<void> forgotPassword(String identifier) async {
    emit(const ForgotPasswordState.loading());
    try {
      final response = await loginApiService.forgotPassword(
        ForgotPasswordRequest(identifier: identifier),
      );
      if (response.status && response.data != null) {
        emit(ForgotPasswordState.sentOtpSuccess(response.data!.phone, response.message));
      } else {
        emit(ForgotPasswordState.error(response.message));
      }
    } catch (e) {
      emit(ForgotPasswordState.error(ErrorHandler.getFailure(e).message));
    }
  }

  Future<void> verifyOtp(String phone, String code) async {
    emit(const ForgotPasswordState.loading());
    try {
      final response = await loginApiService.verifyOtp(
        VerifyOtpRequest(phone: phone, code: code),
      );
      if (response.status) {
        emit(ForgotPasswordState.verifyOtpSuccess(response.message));
      } else {
        emit(ForgotPasswordState.error(response.message));
      }
    } catch (e) {
      emit(ForgotPasswordState.error(ErrorHandler.getFailure(e).message));
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const ForgotPasswordState.loading());
    try {
      final response = await loginApiService.resetPassword(
        ResetPasswordRequest(
          phone: phone,
          code: code,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      );
      if (response.status) {
        emit(ForgotPasswordState.resetPasswordSuccess(response.message));
      } else {
        emit(ForgotPasswordState.error(response.message));
      }
    } catch (e) {
      emit(ForgotPasswordState.error(ErrorHandler.getFailure(e).message));
    }
  }
}
