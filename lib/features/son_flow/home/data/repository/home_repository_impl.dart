import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/home/data/data_sources/api/home_api_service.dart';
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
Future<Result<ProfileResponseModel>> updateProfile({required String name, required String phone}) async {
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


}
