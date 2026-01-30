import 'package:json_annotation/json_annotation.dart';

part 'register_response_model.g.dart';

@JsonSerializable(createToJson: false)
class RegisterResponseModel {
  RegisterResponseModel({
    required this.status,
    required this.message,
    required this.data,
    required this.errors,
  });

  final bool status;
  final String message;
  final Data data;
  final Map<String, dynamic>? errors;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class Data {
  Data({required this.token, required this.user});

  final String token;
  final User? user;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@JsonSerializable(createToJson: false)
class User {
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
  });

  final String name;
  final String email;
  final String phone;

  @JsonKey(name: 'user_type')
  final String? userType;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
