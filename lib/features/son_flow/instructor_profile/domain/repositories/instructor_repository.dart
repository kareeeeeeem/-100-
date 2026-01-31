import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/instructor_profile/data/models/instructor_profile_model.dart';

abstract class InstructorRepository {
  Future<Result<InstructorProfileModel>> getInstructorProfile(String instructorId);
}
