import 'package:flutter/foundation.dart';
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

  Future<void> getProfileData({bool isSilent = false}) async {
    if (!isSilent) emit(ProfileLoading());
    
    // Use individual awaits to handle errors specifically for each call
    // This prevents a 500 error in one API (like dashboard stats) from breaking the whole profile
    
    final profileResult = await _homeRepository.getProfileData();
    final coursesResult = await _homeRepository.getMyCourses();
    
    // Gracefully handle dashboard stats failure
    DashboardStatsModel? stats;
    try {
      final statsResult = await _dashboardRepository.getDashboardStats();
      if (statsResult.isSuccess) {
        stats = statsResult.data;
      } else {
        debugPrint("⚠️ Dashboard Stats failed: ${statsResult.failure?.message}");
      }
    } catch (e) {
      debugPrint("❌ Dashboard Stats exception: $e");
    }

    if (profileResult.isSuccess) {
      final profileData = profileResult.data!.data;
      
      // حفظ البيانات المحدثة في الـ Cache لضمان تحديث الـ Header في أي مكان
      if (profileData?.name != null) {
        await _jwtService.saveUserName(profileData!.name!);
      }
      if (profileData?.image != null) {
        await _jwtService.saveUserAvatar(profileData!.image!);
      }

      final courses = coursesResult.isSuccess ? coursesResult.data!.data : <MyCourseItemModel>[];

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
      if (!isSilent) emit(ProfileError(profileResult.failure?.message ?? "حدث خطأ غير متوقع"));
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

Future<void> updateProfileData({required String name, required String email}) async {
  emit(ProfileUpdateLoading());
  final result = await _homeRepository.updateProfile(name: name, email: email);
  if (result.isSuccess) {
    // Update JWT cache
    await _jwtService.saveUserName(name);
    // We don't have email in JWT service usually but we update name/avatar
    emit(ProfileUpdateSuccess(result.data?.message ?? "تم تحديث البيانات بنجاح"));
    // Refresh profile data silently to get updated info in the UI (like emails etc)
    await getProfileData(isSilent: true);
  } else {
    emit(ProfileUpdateError(result.failure?.message ?? "فشل تحديث البيانات"));
  }
}

Future<void> changeProfilePassword({
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  emit(ChangePasswordLoading());
  final result = await _homeRepository.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
    newPasswordConfirmation: confirmPassword,
  );
  if (result.isSuccess) {
    emit(ChangePasswordSuccess("تم تغيير كلمة السر بنجاح"));
  } else {
    emit(ChangePasswordError(result.failure?.message ?? "فشل تغيير كلمة السر"));
  }
}
}