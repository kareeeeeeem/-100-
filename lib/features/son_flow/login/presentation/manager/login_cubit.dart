import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/enums/request_status_enum.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/login/data/model/social_login_request_model.dart';
import 'package:lms/features/son_flow/login/data/model/login_request_model.dart';
import 'package:lms/features/son_flow/login/data/model/login_response_model.dart';
import 'package:lms/features/son_flow/login/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/login/presentation/manager/login_state.dart';

import 'package:lms/core/service/firebase_auth_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;
  final FirebaseAuthService _firebaseAuthService;

  LoginCubit(this.loginRepository, this._firebaseAuthService) : super(const LoginState());

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(loginStatus: RequestStatus.loading));
    final user = await _firebaseAuthService.signInWithGoogle();
    
    if (user != null) {
      final email = (user.email != null && user.email!.isNotEmpty) 
          ? user.email! 
          : "${user.uid}@gmail.com"; // Fallback to UID if email is missing
      
      print("📡 [LoginCubit] Sending Social Login Request: email=$email, provider=google");

      final Result<LoginResponseModel> result = await loginRepository.socialLogin(
        SocialLoginRequestModel(
          name: user.displayName ?? "User",
          email: email,
          provider: 'google',
          providerId: user.uid,
        ),
      );

      result.fold(
        (response) {
          emit(state.copyWith(
            loginStatus: RequestStatus.success,
            userType: response.data.user.userType,
          ));
        },
        (failure) {
          emit(state.copyWith(
            loginStatus: RequestStatus.error,
            loginErrorMessage: failure.message,
          ));
        },
      );
    } else {
      emit(state.copyWith(
        loginStatus: RequestStatus.error,
        loginErrorMessage: "فشل تسجيل الدخول بواسطة جوجل",
      ));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(state.copyWith(loginStatus: RequestStatus.loading));
    final user = await _firebaseAuthService.signInWithFacebook();
    
    if (user != null) {
      final email = (user.email != null && user.email!.isNotEmpty) 
          ? user.email! 
          : "${user.uid}@facebook.com"; // Fallback to UID if email is missing

      print("📡 [LoginCubit] Sending Social Login Request: email=$email, provider=facebook");

      final Result<LoginResponseModel> result = await loginRepository.socialLogin(
        SocialLoginRequestModel(
          name: user.displayName ?? "User",
          email: email,
          provider: 'facebook',
          providerId: user.uid,
        ),
      );

      result.fold(
        (response) {
          emit(state.copyWith(
            loginStatus: RequestStatus.success,
            userType: response.data.user.userType,
          ));
        },
        (failure) {
          emit(state.copyWith(
            loginStatus: RequestStatus.error,
            loginErrorMessage: failure.message,
          ));
        },
      );
    } else {
      emit(state.copyWith(
        loginStatus: RequestStatus.error,
        loginErrorMessage: "فشل تسجيل الدخول بواسطة فيسبوك",
      ));
    }
  }

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
