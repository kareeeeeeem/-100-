part of 'my_courses_cubit.dart';

enum MyCoursesStatus { initial, loading, success, error }

class MyCoursesState extends Equatable {
  final MyCoursesStatus status;
  final List<MyCourseItemModel> courses;
  final String? errorMessage;

  const MyCoursesState({
    this.status = MyCoursesStatus.initial,
    this.courses = const [],
    this.errorMessage,
  });

  MyCoursesState copyWith({
    MyCoursesStatus? status,
    List<MyCourseItemModel>? courses,
    String? errorMessage,
  }) {
    return MyCoursesState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, courses, errorMessage];
}