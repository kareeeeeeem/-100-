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
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<CourseDetailsResponseModel> getCourseDetails({required int courseId}); 
  Future<NotificationsResponseModel> getNotifications();
  Future<void> markAsRead(int id);
  Future<List<CategoryModel>> getCategories();
  Future<List<CourseModel>> searchCourses(String query);
  Future<void> checkout({
    required int courseId,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  });
  Future<void> logout();
  Future<void> deleteAccount();
  Future<bool> toggleFavorite(int courseId);
}