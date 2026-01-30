import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable(createToJson: false)
class LoginResponseModel {
  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
    required this.errors,
  });

  final bool status;
  final String message;
  final Data data;
  final Map<String, dynamic>? errors;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class Data {
  Data({required this.token, required this.user});

  final String token;
  final User user;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@JsonSerializable(createToJson: false)
class User {
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.userTypeText,
    required this.identityNumber,
  });

  final String name;
  final String email;
  final String phone;

  @JsonKey(name: 'user_type')
  final String userType;

  @JsonKey(name: 'user_type_text')
  final String userTypeText;

  @JsonKey(name: 'identity_number')
  final String? identityNumber;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
