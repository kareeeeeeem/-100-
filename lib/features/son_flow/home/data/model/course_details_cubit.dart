import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/models/result.dart'; 
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';

// --- الحالات (States) لازم تكون موجودة هنا أو في ملف منفصل ---
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

// --- الكيوبيت (Cubit) ---
class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  final HomeRepository homeRepository; 

  CourseDetailsCubit(this.homeRepository) : super(CourseDetailsInitial());

  Future<void> fetchCourseDetails(int id) async {
    emit(CourseDetailsLoading());
    
    final result = await homeRepository.getCourseDetails(courseId: id);
    
    // التعامل مع الـ Result بناءً على هيكلة مشروعك
    if (result.isSuccess) {
      emit(CourseDetailsSuccess(result.data!));
    } else {
      emit(CourseDetailsError(result.failure?.message ?? "فشل تحميل تفاصيل الدورة"));
    }
  }
}