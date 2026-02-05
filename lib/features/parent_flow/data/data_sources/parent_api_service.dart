import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/parent_flow/data/models/add_child_response_model.dart';
import 'package:lms/features/parent_flow/data/models/child_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_notification_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_payment_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_profile_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';

class ParentApiService {
  final ApiService _apiService;
  final JwtService _jwtService;

  ParentApiService(this._apiService, this._jwtService);

  Future<ParentProfileModel> getProfile() async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.parentProfile,
      headers: {'Authorization': 'Bearer $token'},
    );
    // Handle wrapped response
    final Map<String, dynamic> data = response is Map && response.containsKey('data') 
        ? response['data'] 
        : response;
    return ParentProfileModel.fromJson(data);
  }

  Future<List<ChildModel>> getChildren() async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.parentChildren,
      headers: {'Authorization': 'Bearer $token'},
    );
    final List<dynamic> data = response is List ? response : (response['data'] ?? []);
    return data.map((e) => ChildModel.fromJson(e)).toList();
  }

  Future<AddChildResponseModel> addChild(Map<String, dynamic> body) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.post(
      ApiConstants.parentChildren,
      body: body,
      headers: {'Authorization': 'Bearer $token'},
    );
    return AddChildResponseModel.fromJson(response);
  }

  Future<ChildModel> getChildDetails(int childId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.childDetails(childId),
      headers: {'Authorization': 'Bearer $token'},
    );
    // Handle case where API returns a list (e.g., [childData])
    final Map<String, dynamic> data = response is List && response.isNotEmpty
        ? response.first
        : response;
    return ChildModel.fromJson(data);
  }

  Future<void> updateChild(int childId, Map<String, dynamic> body) async {
    final token = await _jwtService.getAccessToken();
    await _apiService.put(
      ApiConstants.childDetails(childId),
      body: body,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<List<MyCourseItemModel>> getParentCourses() async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.parentCourses,
      headers: {'Authorization': 'Bearer $token'},
    );
    final List<dynamic> data = response is List ? response : (response['data'] ?? []);
    return data.map((e) => MyCourseItemModel.fromJson(e)).toList();
  }

  Future<List<dynamic>> getChildExamResults(int childId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.childExamResults(childId),
      headers: {'Authorization': 'Bearer $token'},
    );
    final List<dynamic> data = response is List ? response : (response['data'] ?? []);
    return data;
  }

  Future<List<ParentPaymentModel>> getPayments() async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.parentPayments,
      headers: {'Authorization': 'Bearer $token'},
    );
    
    final List<dynamic> data = response is List ? response : (response['data'] ?? []);
    return data.map((e) => ParentPaymentModel.fromJson(e)).toList();
  }

  Future<List<ParentNotificationModel>> getNotifications() async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.notifications,
      headers: {'Authorization': 'Bearer $token'},
    );
    // Handle both List and wrapped data
    final List<dynamic> data = response is List ? response : (response['data'] ?? []);
    return data.map((e) => ParentNotificationModel.fromJson(e)).toList();
  }

  Future<void> checkout({
    required int courseId,
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  }) async {
    final token = await _jwtService.getAccessToken();
    await _apiService.post(
      ApiConstants.checkout,
      body: {
        'course_id': courseId,
        'amount': amount,
        'price': amount,
        'card_number': cardNumber,
        'expiry_date': expiryDate,
        'cvv': cvv,
        'payment_type': paymentType,
      },
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<void> logout() async {
    await _jwtService.clearAll();
  }

  Future<Map<String, dynamic>> getLiveSessions() async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.liveSessions,
      headers: {'Authorization': 'Bearer $token'},
    );
     // If response is map, return it. If list, wrap it?
     // The log showed data: {available_now: ...}. So it's a Map.
     return response is Map<String, dynamic> ? response : {};
  }
}
