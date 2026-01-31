import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/login/data/model/notifications_response_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService homeApiService;

  const HomeRepositoryImpl(this.homeApiService);

  @override
  Future<Result<HomeResponseModel>> getHomeData() async {
    try {
      final result = await homeApiService.getHomeData();
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<MyCoursesResponseModel>> getMyCourses() async {
    try {
      final result = await homeApiService.getMyCourses();
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<ProfileResponseModel>> getProfileData() async {
    try {
      final result = await homeApiService.getProfileData();
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<ProfileResponseModel>> updateProfile(
      {required String name, required String phone}) async {
    try {
      final result = await homeApiService.updateProfile(name: name, phone: phone);
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<NotificationsResponseModel>> getNotifications() async {
    try {
      final result = await homeApiService.getNotifications();
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<CourseDetailsResponseModel>> getCourseDetails(
      {required int courseId}) async {
    try {
      final result = await homeApiService.getCourseDetails(courseId: courseId);
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      await homeApiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      return Result.success(null);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<void>> markNotificationAsRead(int id) async {
    try {
      await homeApiService.markAsRead(id);
      return Result.success(null);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    try {
      final result = await homeApiService.getCategories();
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<List<CourseModel>>> searchCourses(String query) async {
    try {
      final result = await homeApiService.searchCourses(query);
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<void>> checkout({
    required int courseId,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  }) async {
    try {
      await homeApiService.checkout(
        courseId: courseId,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
        paymentType: paymentType,
      );
      return Result.success(null);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await homeApiService.logout();
      return Result.success(null);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await homeApiService.deleteAccount();
      return Result.success(null);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<bool>> toggleFavorite(int courseId) async {
    try {
      final result = await homeApiService.toggleFavorite(courseId);
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }
}
