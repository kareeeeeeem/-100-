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