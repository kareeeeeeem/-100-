import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/instructor_profile/data/models/instructor_profile_model.dart'; 
import 'package:lms/features/son_flow/instructor_profile/domain/repositories/instructor_repository.dart';
import 'package:lms/features/son_flow/instructor_profile/presentation/manager/instructor_state.dart';

class InstructorCubit extends Cubit<InstructorState> {
  final InstructorRepository _repository;

  InstructorCubit(this._repository) : super(InstructorInitial());

  Future<void> getInstructorProfile(String instructorId) async {
    emit(InstructorLoading());
    final result = await _repository.getInstructorProfile(instructorId);

    if (result.isSuccess) {
      // بنبعت الداتا للموديل الجديد مباشرة
      emit(InstructorProfileLoaded(result.data!)); 
    } else {
      emit(InstructorError(result.failure?.message ?? 'Unknown Error'));
    }
  }
}