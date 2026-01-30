import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final HomeRepository _homeRepository;

  ProfileCubit(this._homeRepository) : super(ProfileInitial());

Future<void> getProfileData() async {
    emit(ProfileLoading());
    final result = await _homeRepository.getProfileData();
    
    if (result.isSuccess) {
       emit(ProfileSuccess(result.data!));
    } else {
       // ضفنا ?. قبل الميد و ?? كرسالة احتياطية
       emit(ProfileError(result.failure?.message ?? "حدث خطأ غير متوقع"));
    }
}
}