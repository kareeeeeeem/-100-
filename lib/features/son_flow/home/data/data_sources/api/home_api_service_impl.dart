import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/transaction_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/notifications_response_model.dart';

class HomeApiServiceImpl implements HomeApiService {
  final ApiService apiService;
  final JwtService jwtService;

  HomeApiServiceImpl(this.apiService, this.jwtService);

  @override
  Future<HomeResponseModel> getHomeData() async {
    final response = await apiService.get(ApiConstants.home);
    // Debug: Print slider images
    if (response['data']?['slider'] != null) {
      print('📡 Home API Slider Images:');
      for (var slide in response['data']['slider']) {
        print('   - ${slide['image']}');
      }
    }
    return HomeResponseModel.fromJson(response);
  }

  @override
  Future<MyCoursesResponseModel> getMyCourses() async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.get(
      ApiConstants.myCourses,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return MyCoursesResponseModel.fromJson(response);
  }

  @override
  Future<ProfileResponseModel> getProfileData() async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.get(
      ApiConstants.profile,
      headers: {'Authorization': 'Bearer $token'},
    );
    return ProfileResponseModel.fromJson(response);
  }

  @override
  Future<ProfileResponseModel> updateProfile({required String name, required String email}) async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.post(
      ApiConstants.updateProfile,
      body: {
        'name': name,
        'email': email,
      },
      headers: {'Authorization': 'Bearer $token'},
    );
    return ProfileResponseModel.fromJson(response);
  }

  @override
  Future<CourseDetailsResponseModel> getCourseDetails({required int courseId}) async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.get(
      ApiConstants.courseDetails(courseId),
      headers: {'Authorization': 'Bearer $token'},
    );
    // Debug: Print the raw response to see image paths
    print('📡 API Response for course $courseId:');
    print('   Thumbnail: ${response['data']?['thumbnail']}');
    print('   Instructor Image: ${response['data']?['instructor']?['image']}');
    return CourseDetailsResponseModel.fromJson(response);
  }

  @override
  Future<NotificationsResponseModel> getNotifications() async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.get(
      ApiConstants.notifications,
      headers: {'Authorization': 'Bearer $token'},
    );
    return NotificationsResponseModel.fromJson(response);
  }

  @override
  Future<void> markAsRead(int id) async {
    final token = await jwtService.getAccessToken();
    await apiService.post(
      ApiConstants.markAsRead(id),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  @override
  Future<void> logout() async {
    final token = await jwtService.getAccessToken();
    await apiService.post(
      ApiConstants.logout,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  @override
  Future<void> deleteAccount() async {
    final token = await jwtService.getAccessToken();
    await apiService.post(
      ApiConstants.deleteAccount,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  @override
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.post(
      ApiConstants.changePassword,
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
      headers: {'Authorization': 'Bearer $token'},
    );
    return response;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.get(
      ApiConstants.categories,
      headers: {'Authorization': 'Bearer $token'},
    );
    final List data = response['data'] is List ? response['data'] : [];
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<List<CourseModel>> searchCourses(String query) async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.get(
      ApiConstants.courses,
      queryParameters: {'search': query},
      headers: {'Authorization': 'Bearer $token'},
    );
    final List data = response['data'] is List ? response['data'] : [];
    return data.map((e) => CourseModel.fromJson(e)).toList();
  }

  @override
  Future<void> checkout({
    required int courseId,
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  }) async {
    final token = await jwtService.getAccessToken();
    await apiService.post(
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

  @override
  Future<Map<String, dynamic>> processPayment({
    required int courseId,
    required String paymentMethod,
    String? guardianPhone,
  }) async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.post(
      ApiConstants.paymentCheckout,
      body: {
        'course_id': courseId,
        'payment_method': paymentMethod,
        if (guardianPhone != null) 'guardian_phone': guardianPhone,
      },
      headers: {'Authorization': 'Bearer $token'},
    );
    return response;
  }

  @override
  Future<TransactionResponseModel> getTransactions() async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.get(
      ApiConstants.transactions,
      headers: {'Authorization': 'Bearer $token'},
    );
    return TransactionResponseModel.fromJson(response);
  }
}