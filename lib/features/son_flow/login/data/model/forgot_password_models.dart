import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_models.g.dart';

@JsonSerializable()
class ForgotPasswordRequest {
  final String identifier;

  ForgotPasswordRequest({required this.identifier});

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class ForgotPasswordResponse {
  final bool status;
  final String message;
  final ForgotPasswordData? data;
  final dynamic errors;

  ForgotPasswordResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);
}

@JsonSerializable()
class ForgotPasswordData {
  final String phone;

  ForgotPasswordData({required this.phone});

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordDataFromJson(json);
}

@JsonSerializable()
class VerifyOtpRequest {
  final String phone;
  final String code;

  VerifyOtpRequest({required this.phone, required this.code});

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String phone;
  final String code;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  ResetPasswordRequest({
    required this.phone,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

@JsonSerializable()
class AuthDefaultResponse {
  final bool status;
  final String message;
  final dynamic data;
  final dynamic errors;

  AuthDefaultResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors,
  });

  factory AuthDefaultResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthDefaultResponseFromJson(json);
}
