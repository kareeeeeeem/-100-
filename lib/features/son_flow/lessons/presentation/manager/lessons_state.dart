import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';

abstract class LessonsState {}

class LessonsInitial extends LessonsState {}

class LessonsLoading extends LessonsState {}

class LessonsLoaded extends LessonsState {
  final List<Lesson> lessons;

  LessonsLoaded(this.lessons);
}

class LessonsError extends LessonsState {
  final String message;

  LessonsError(this.message);
}
