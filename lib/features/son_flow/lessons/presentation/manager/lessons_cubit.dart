import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/lessons/domain/repositories/lessons_repository.dart';
import 'package:lms/features/son_flow/lessons/presentation/manager/lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final LessonsRepository _repository;

  LessonsCubit(this._repository) : super(LessonsInitial());

  Future<void> loadSectionLessons(String sectionId) async {
    emit(LessonsLoading());
    final result = await _repository.getSectionLessons(sectionId);

    if (result.isSuccess) {
      emit(LessonsLoaded(result.data ?? []));
    } else {
      emit(LessonsError(result.failure?.message ?? 'حدث خطأ أثناء تحميل الدروس'));
    }
  }
}
