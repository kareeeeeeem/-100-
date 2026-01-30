import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/on_boarding/domain/repository/on_boarding_repository.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  final OnBoardingRepository onBoardingRepository;

  OnBoardingCubit(this.onBoardingRepository) : super(OnBoardingInitial());

  Future<void> completeOnBoarding() async {
    await onBoardingRepository.completeOnBoarding();
  }
}
