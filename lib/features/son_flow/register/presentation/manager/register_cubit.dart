import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/enums/request_status_enum.dart'; // ده أهم سطر ناقص عندك
import 'package:lms/features/son_flow/register/data/model/register_request_model.dart';
import 'package:lms/features/son_flow/register/domain/repository/register_repository.dart';
import 'package:lms/features/son_flow/register/presentation/manager/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository registerRepository;

  RegisterCubit(this.registerRepository) : super( RegisterState());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String userType,
  }) async {
    // تأكد أن الاسم قبل النقطتين هو registerStatus
    emit(state.copyWith(registerStatus: RequestStatus.loading));
    
    final result = await registerRepository.register(
      RegisterRequestModel(
        name: name,
        email: email,
        password: password,
        phone: phone,
        userType: userType,
      ),
    );

    result.fold(
      (_) {
        emit(state.copyWith(registerStatus: RequestStatus.success));
      },
      (failure) {
        emit(
          state.copyWith(
            registerStatus: RequestStatus.error,
            registerErrorMessage: failure.message,
          ),
        );
      },
    );
  }
}