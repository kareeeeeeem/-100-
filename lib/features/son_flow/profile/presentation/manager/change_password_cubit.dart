import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';

abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordError extends ChangePasswordState {
  final String message;

  ChangePasswordError(this.message);
}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final HomeRepository _repository;

  ChangePasswordCubit(this._repository) : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    emit(ChangePasswordLoading());
    
    final result = await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );

    if (result.isSuccess) {
      emit(ChangePasswordSuccess());
    } else {
      emit(ChangePasswordError(result.failure?.message ?? 'خطأ في تغيير كلمة المرور'));
    }
  }
}
