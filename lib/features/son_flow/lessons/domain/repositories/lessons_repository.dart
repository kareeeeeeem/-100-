import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';

abstract class LessonsRepository {
  Future<Result<List<Lesson>>> getSectionLessons(String sectionId);
}
