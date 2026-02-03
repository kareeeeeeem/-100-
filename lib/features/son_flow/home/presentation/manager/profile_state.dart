import '../../data/model/profile_response_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileSuccess extends ProfileState {
  final ProfileResponseModel profileModel;
  ProfileSuccess(this.profileModel);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class LogoutLoading extends ProfileState {}
class LogoutSuccess extends ProfileState {}
class LogoutError extends ProfileState {
  final String message;
  LogoutError(this.message);
}

class DeleteAccountLoading extends ProfileState {}
class DeleteAccountSuccess extends ProfileState {}
class DeleteAccountError extends ProfileState {
  final String message;
  DeleteAccountError(this.message);
}

// Profile Updates
class ProfileUpdateLoading extends ProfileState {}
class ProfileUpdateSuccess extends ProfileState {
  final String message;
  ProfileUpdateSuccess(this.message);
}
class ProfileUpdateError extends ProfileState {
  final String message;
  ProfileUpdateError(this.message);
}

// Change Password
class ChangePasswordLoading extends ProfileState {}
class ChangePasswordSuccess extends ProfileState {
  final String message;
  ChangePasswordSuccess(this.message);
}
class ChangePasswordError extends ProfileState {
  final String message;
  ChangePasswordError(this.message);
}