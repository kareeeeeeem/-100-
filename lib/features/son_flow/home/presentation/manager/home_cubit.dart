import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;

  HomeCubit(this.homeRepository) : super(const HomeState());

  Future<void> fetchHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    final result = await homeRepository.getHomeData();
    
    result.fold(
      (data) => emit(state.copyWith(
        status: HomeStatus.success,
        homeData: data,
      )),
      (failure) => emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: failure.message,
      )),
    );
  }
}
