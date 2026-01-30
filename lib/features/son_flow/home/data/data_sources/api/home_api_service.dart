import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/notifications_response_model.dart';

abstract class HomeApiService {
  Future<HomeResponseModel> getHomeData();
  Future<MyCoursesResponseModel> getMyCourses();
  Future<ProfileResponseModel> getProfileData();
  Future<ProfileResponseModel> updateProfile({required String name, required String phone});
  Future<CourseDetailsResponseModel> getCourseDetails({required int courseId});
  Future<NotificationsResponseModel> getNotifications();
}