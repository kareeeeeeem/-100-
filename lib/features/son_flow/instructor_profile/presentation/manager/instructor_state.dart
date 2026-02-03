import 'package:lms/features/son_flow/instructor_profile/data/models/instructor_profile_model.dart';

abstract class InstructorState {}

class InstructorInitial extends InstructorState {}

class InstructorLoading extends InstructorState {}

class InstructorProfileLoaded extends InstructorState {
  // غيرنا النوع هنا للموديل الجديد
  final InstructorProfileModel profile; 

  InstructorProfileLoaded(this.profile);
}

class InstructorError extends InstructorState {
  final String message;
  InstructorError(this.message);
}