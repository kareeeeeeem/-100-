// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordRequest(identifier: json['identifier'] as String);

Map<String, dynamic> _$ForgotPasswordRequestToJson(
  ForgotPasswordRequest instance,
) => <String, dynamic>{'identifier': instance.identifier};

ForgotPasswordResponse _$ForgotPasswordResponseFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordResponse(
  status: json['status'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : ForgotPasswordData.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'],
);

Map<String, dynamic> _$ForgotPasswordResponseToJson(
  ForgotPasswordResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
};

ForgotPasswordData _$ForgotPasswordDataFromJson(Map<String, dynamic> json) =>
    ForgotPasswordData(phone: json['phone'] as String);

Map<String, dynamic> _$ForgotPasswordDataToJson(ForgotPasswordData instance) =>
    <String, dynamic>{'phone': instance.phone};

VerifyOtpRequest _$VerifyOtpRequestFromJson(Map<String, dynamic> json) =>
    VerifyOtpRequest(
      phone: json['phone'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$VerifyOtpRequestToJson(VerifyOtpRequest instance) =>
    <String, dynamic>{'phone': instance.phone, 'code': instance.code};

ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequest(
  phone: json['phone'] as String,
  code: json['code'] as String,
  password: json['password'] as String,
  passwordConfirmation: json['password_confirmation'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{
  'phone': instance.phone,
  'code': instance.code,
  'password': instance.password,
  'password_confirmation': instance.passwordConfirmation,
};

AuthDefaultResponse _$AuthDefaultResponseFromJson(Map<String, dynamic> json) =>
    AuthDefaultResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'],
      errors: json['errors'],
    );

Map<String, dynamic> _$AuthDefaultResponseToJson(
  AuthDefaultResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
};
