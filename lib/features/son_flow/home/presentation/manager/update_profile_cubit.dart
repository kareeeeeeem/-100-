import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';

abstract class UpdateProfileState {}
class UpdateProfileInitial extends UpdateProfileState {}
class UpdateProfileLoading extends UpdateProfileState {}
class UpdateProfileSuccess extends UpdateProfileState {
  final ProfileResponseModel profile;
  UpdateProfileSuccess(this.profile);
}
class UpdateProfileError extends UpdateProfileState {
  final String message;
  UpdateProfileError(this.message);
}

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final HomeRepository _repository;
  UpdateProfileCubit(this._repository) : super(UpdateProfileInitial());

  Future<void> updateProfile({required String name, required String phone}) async {
    emit(UpdateProfileLoading());
    final result = await _repository.updateProfile(name: name, phone: phone);
    if (result.isSuccess) {
      emit(UpdateProfileSuccess(result.data!));
    } else {
      emit(UpdateProfileError(result.failure?.message ?? "خطأ في التحديث"));
    }
  }
}