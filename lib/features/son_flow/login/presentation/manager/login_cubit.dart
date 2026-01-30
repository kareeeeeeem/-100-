import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/enums/request_status_enum.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/login/data/model/login_request_model.dart';
import 'package:lms/features/son_flow/login/data/model/login_response_model.dart';
import 'package:lms/features/son_flow/login/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/login/presentation/manager/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;

  LoginCubit(this.loginRepository) : super(const LoginState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(loginStatus: RequestStatus.loading));
    final Result<LoginResponseModel> result = await loginRepository.login(
      LoginRequestModel(email: email, password: password),
    );

    result.fold(
  (response) {
    emit(state.copyWith(
      loginStatus: RequestStatus.success,
      userType: response.data.user.userType, // بنمرره للـ UI هنا
    ));
  },
  (failure) {
        emit(
          state.copyWith(
            loginStatus: RequestStatus.error,
            loginErrorMessage: failure.message,
          ),
        );
      },
    );
  }
}
