import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';

abstract class CourseDetailsState {}
class CourseDetailsInitial extends CourseDetailsState {}
class CourseDetailsLoading extends CourseDetailsState {}
class CourseDetailsSuccess extends CourseDetailsState {
  final CourseDetailsResponseModel model;
  CourseDetailsSuccess(this.model);
}
class CourseDetailsError extends CourseDetailsState {
  final String message;
  CourseDetailsError(this.message);
}

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  final HomeApiService apiService;
  CourseDetailsCubit(this.apiService) : super(CourseDetailsInitial());

  Future<void> fetchCourseDetails(int id) async {
    emit(CourseDetailsLoading());
    try {
      final result = await apiService.getCourseDetails(courseId: id);
      emit(CourseDetailsSuccess(result));
    } catch (e) {
      emit(CourseDetailsError("فشل تحميل تفاصيل الدورة"));
    }
  }
}