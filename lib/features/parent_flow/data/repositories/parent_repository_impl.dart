import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/parent_flow/data/data_sources/parent_api_service.dart';
import 'package:lms/features/parent_flow/data/models/add_child_response_model.dart';
import 'package:lms/features/parent_flow/data/models/child_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_notification_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_payment_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_profile_model.dart';
import 'package:lms/features/parent_flow/domain/repositories/parent_repository.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';

class ParentRepositoryImpl implements ParentRepository {
  final ParentApiService _apiService;

  ParentRepositoryImpl(this._apiService);

  @override
  Future<Result<ParentProfileModel>> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<List<ChildModel>>> getChildren() async {
    try {
      final response = await _apiService.getChildren();
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<AddChildResponseModel>> addChild(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.addChild(data);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<ChildModel>> getChildDetails(int childId) async {
    try {
      final response = await _apiService.getChildDetails(childId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<void>> updateChild(int childId, Map<String, dynamic> data) async {
    try {
      await _apiService.updateChild(childId, data);
      return Result.success(null);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<void>> deleteChild(int childId) async {
    try {
      await _apiService.deleteChild(childId);
      return Result.success(null);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<List<MyCourseItemModel>>> getParentCourses() async {
    try {
      final response = await _apiService.getParentCourses();
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<List<dynamic>>> getChildExamResults(int childId) async {
    try {
      final response = await _apiService.getChildExamResults(childId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<List<ParentPaymentModel>>> getPayments() async {
    try {
      final result = await _apiService.getPayments();
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<List<ParentNotificationModel>>> getNotifications() async {
    try {
      final result = await _apiService.getNotifications();
      return Result.success(result);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<void>> checkout({
    required int courseId,
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  }) async {
    try {
      await _apiService.checkout(
        courseId: courseId,
        amount: amount,
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
      await _apiService.logout();
      return Result.success(null);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getLiveSessions() async {
    try {
      final response = await _apiService.getLiveSessions();
      return Result.success(response);
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }
}
