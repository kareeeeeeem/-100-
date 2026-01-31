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