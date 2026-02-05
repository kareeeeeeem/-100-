import 'package:lms/core/models/result.dart';
import 'package:lms/features/parent_flow/data/models/add_child_response_model.dart';
import 'package:lms/features/parent_flow/data/models/child_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_notification_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_payment_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_profile_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';

abstract class ParentRepository {
  Future<Result<ParentProfileModel>> getProfile();
  Future<Result<List<ChildModel>>> getChildren();
  Future<Result<AddChildResponseModel>> addChild(Map<String, dynamic> data);
  Future<Result<ChildModel>> getChildDetails(int childId);
  Future<Result<void>> updateChild(int childId, Map<String, dynamic> data);
  Future<Result<void>> deleteChild(int childId);
  Future<Result<List<MyCourseItemModel>>> getParentCourses();
  Future<Result<List<dynamic>>> getChildExamResults(int childId);
  Future<Result<List<ParentNotificationModel>>> getNotifications();
  Future<Result<List<ParentPaymentModel>>> getPayments();
  Future<Result<void>> checkout({
    required int courseId,
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  });

  Future<Result<void>> logout();

  Future<Result<Map<String, dynamic>>> getLiveSessions();
}
