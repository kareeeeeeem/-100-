import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';

part 'login_request_model.g.dart';

@Freezed(fromJson: false, toJson: true)
sealed class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({
    required String email,
    required String password,
    @JsonKey(name: 'device_id') String? deviceId,
  }) = _LoginRequestModel;
}
