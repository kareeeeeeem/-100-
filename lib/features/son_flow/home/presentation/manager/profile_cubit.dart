import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';
import 'package:lms/features/son_flow/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:lms/features/son_flow/dashboard/data/models/dashboard_stats_model.dart';
import 'package:lms/core/models/result.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final HomeRepository _homeRepository;
  final DashboardRepository _dashboardRepository;
  final JwtService _jwtService;

  ProfileCubit(this._homeRepository, this._dashboardRepository, this._jwtService) : super(ProfileInitial());

  Future<void> getProfileData() async {
    emit(ProfileLoading());
    
    final results = await Future.wait([
      _homeRepository.getProfileData(),
      _homeRepository.getMyCourses(),
      _dashboardRepository.getDashboardStats(),
    ]);

    final profileResult = results[0] as Result<ProfileResponseModel>;
    final coursesResult = results[1] as Result<MyCoursesResponseModel>;
    final statsResult = results[2] as Result<DashboardStatsModel>;

    if (profileResult.isSuccess) {
      final profileData = profileResult.data!.data;
      final courses = coursesResult.isSuccess ? coursesResult.data!.data : <MyCourseItemModel>[];
      final stats = statsResult.isSuccess ? statsResult.data : null;

      final mergedProfile = ProfileResponseModel(
        status: profileResult.data!.status,
        message: profileResult.data!.message,
        data: ProfileData(
          name: profileData?.name,
          email: profileData?.email,
          image: profileData?.image,
          enrolledCoursesCount: profileData?.enrolledCoursesCount,
          completedCoursesCount: profileData?.completedCoursesCount,
          certificatesCount: profileData?.certificatesCount,
          overallProgress: profileData?.overallProgress,
          recentCourses: courses,
          dashboardStats: stats,
        ),
      );

      emit(ProfileSuccess(mergedProfile));
    } else {
      emit(ProfileError(profileResult.failure?.message ?? "حدث خطأ غير متوقع"));
    }
  }

Future<void> logout() async {
  emit(LogoutLoading());
  final result = await _homeRepository.logout();
  if (result.isSuccess) {
    await _jwtService.clearAll();
    emit(LogoutSuccess());
  } else {
    emit(LogoutError(result.failure?.message ?? "فشل تسجيل الخروج"));
  }
}

Future<void> deleteAccount() async {
  emit(DeleteAccountLoading());
  final result = await _homeRepository.deleteAccount();
  if (result.isSuccess) {
    await _jwtService.clearAll();
    emit(DeleteAccountSuccess());
  } else {
    emit(DeleteAccountError(result.failure?.message ?? "فشل حذف الحساب"));
  }
}
}