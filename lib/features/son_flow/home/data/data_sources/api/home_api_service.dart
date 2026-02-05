import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/transaction_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/notifications_response_model.dart';

abstract class HomeApiService {
  Future<HomeResponseModel> getHomeData();
  Future<MyCoursesResponseModel> getMyCourses();
  Future<ProfileResponseModel> getProfileData();
  Future<ProfileResponseModel> updateProfile({required String name, required String email});
  Future<Map<String, dynamic>> changePassword({
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
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  });
  Future<Map<String, dynamic>> processPayment({
    required int courseId,
    required String paymentMethod,
    String? guardianPhone,
  });
  Future<void> logout();
  Future<void> deleteAccount();
  Future<TransactionResponseModel> getTransactions();
}