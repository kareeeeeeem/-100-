import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/transaction_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/notifications_response_model.dart';

abstract class HomeRepository {
  Future<Result<HomeResponseModel>> getHomeData();
  Future<Result<MyCoursesResponseModel>> getMyCourses();
  Future<Result<ProfileResponseModel>> getProfileData();
  Future<Result<ProfileResponseModel>> updateProfile({required String name, required String email});
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<Result<NotificationsResponseModel>> getNotifications();
  // تعديل النوع لـ int
  Future<Result<CourseDetailsResponseModel>> getCourseDetails({required int courseId});
  Future<Result<void>> markNotificationAsRead(int id);
  Future<Result<List<CategoryModel>>> getCategories();
  Future<Result<List<CourseModel>>> searchCourses(String query);
  Future<Result<void>> checkout({
    required int courseId,
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  });
  Future<Result<Map<String, dynamic>>> processPayment({
    required int courseId,
    required String paymentMethod,
    String? guardianPhone,
  });
  Future<Result<NoOutput>> logout();
  Future<Result<void>> deleteAccount();
  Future<Result<TransactionResponseModel>> getTransactions();
}
