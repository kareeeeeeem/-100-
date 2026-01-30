import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';
import 'package:lms/features/son_flow/login/data/model/notifications_response_model.dart';

abstract class HomeRepository {
  // هنا العقد الأساسي اللي الـ Cubit بيشوفه
  Future<Result<HomeResponseModel>> getHomeData();
  // السطر اللي هيحل المشكلة ويشيل الخطأ الأحمر من الـ Cubit:
  Future<Result<MyCoursesResponseModel>> getMyCourses();

  Future<Result<ProfileResponseModel>> getProfileData();

  Future<Result<ProfileResponseModel>> updateProfile({required String name, required String phone});

Future<Result<NotificationsResponseModel>> getNotifications();

}
