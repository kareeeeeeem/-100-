import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request_model.freezed.dart';

part 'register_request_model.g.dart';

@Freezed(fromJson: false, toJson: true)
sealed class RegisterRequestModel with _$RegisterRequestModel {
  const factory RegisterRequestModel({
    required String name,
    required String email,
    required String password,
    required String phone,
    @JsonKey(name: 'user_type') required String userType, // أضفنا هذا السطر
    @JsonKey(name: 'device_id') String? deviceId,    
  }) = _RegisterRequestModel;
}
