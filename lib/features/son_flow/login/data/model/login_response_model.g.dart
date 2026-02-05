// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as Map<String, dynamic>?,
    );

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  token: json['token'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

User _$UserFromJson(Map<String, dynamic> json) => User(
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  userType: json['user_type'] as String,
  userTypeText: json['user_type_text'] as String?,
  identityNumber: json['identity_number'] as String?,
  image: json['image'] as String?,
);
