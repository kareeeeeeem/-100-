import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/notifications_response_model.dart';
class HomeApiServiceImpl implements HomeApiService {
  final ApiService apiService;
  final JwtService jwtService; // 1. ضيف الـ JwtService هنا

  HomeApiServiceImpl(this.apiService, this.jwtService); // 2. حدث الـ Constructor

  @override
  Future<HomeResponseModel> getHomeData() async {
    final response = await apiService.get('https://100-academy.com/api/v1/home');
    return HomeResponseModel.fromJson(response);
  }

  @override
  Future<MyCoursesResponseModel> getMyCourses() async {
    // 3. اسحب التوكن من الكاش قبل ما تبعت الطلب
    final token = await jwtService.getAccessToken();

    // 4. ابعت التوكن في الـ Headers عشان السيرفر يقبلك
    final response = await apiService.get(
      'https://100-academy.com/api/v1/my-courses',
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
      'https://100-academy.com/api/v1/profile',
      headers: {'Authorization': 'Bearer $token'},
    );
    return ProfileResponseModel.fromJson(response);
  }

@override
Future<ProfileResponseModel> updateProfile({required String name, required String phone}) async {
  final token = await jwtService.getAccessToken();
  final response = await apiService.post(
    'https://100-academy.com/api/v1/profile', 
    body: { // استخدم body وليس data عشان ميطلعش خطأ
      'name': name,
      'phone': phone,
    },
    headers: {'Authorization': 'Bearer $token'},
  );
  return ProfileResponseModel.fromJson(response);
}

  
@override
Future<CourseDetailsResponseModel> getCourseDetails({required int courseId}) async {
  final token = await jwtService.getAccessToken();
  final response = await apiService.get(
    'https://100-academy.com/api/v1/course-details/$courseId', 
    headers: {'Authorization': 'Bearer $token'},
  );
  return CourseDetailsResponseModel.fromJson(response);
}

@override
Future<NotificationsResponseModel> getNotifications() async {
  final token = await jwtService.getAccessToken();
  final response = await apiService.get(
    'https://100-academy.com/api/v1/notifications',
    headers: {'Authorization': 'Bearer $token'},
  );
  return NotificationsResponseModel.fromJson(response);
}
}