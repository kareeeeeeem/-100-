import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'package:lms/features/splash/domain/repository/splash_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this.obBoardingRepository, this.splashRepository)
    : super(const SplashState());

  final OnBoardingRepository obBoardingRepository;
  final SplashRepository splashRepository;
Future<void> checkStatus() async {
  if (isClosed) return;

  bool isCompleted = await obBoardingRepository.isOnBoardingCompleted();
  bool isLoggedIn = await splashRepository.isUserLoggedIn();
  String? type;
  String? name; // ضفنا متغير الاسم

  if (isLoggedIn) {
    type = await splashRepository.getUserType();
    name = await splashRepository.getUserName(); // اسحب الاسم هنا
  }

  if (!isClosed) {
    emit(state.copyWith(
      isOnBoardingCompleted: isCompleted,
      isUserLoggedIn: isLoggedIn,
      userType: type,
      userName: name, // ابعته للـ State
    ));
  }
}

}
