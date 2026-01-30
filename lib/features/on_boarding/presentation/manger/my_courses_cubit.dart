import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';

part 'my_courses_state.dart';

class MyCoursesCubit extends Cubit<MyCoursesState> {
  final HomeRepository homeRepository;

  MyCoursesCubit(this.homeRepository) : super(const MyCoursesState());

  Future<void> fetchMyCourses() async {
    emit(state.copyWith(status: MyCoursesStatus.loading));
    
    final result = await homeRepository.getMyCourses();
    
    result.fold(
      (data) => emit(state.copyWith(
        status: MyCoursesStatus.success,
        courses: data.data,
      )),
      (failure) => emit(state.copyWith(
        status: MyCoursesStatus.error,
        errorMessage: failure.message,
      )),
    );
  }
}