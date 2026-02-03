class SocialLoginRequestModel {
  final String name;
  final String email;
  final String provider;
  final String providerId;
  final String? deviceId;

  SocialLoginRequestModel({
    required this.name,
    required this.email,
    required this.provider,
    required this.providerId,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'provider': provider,
      'provider_id': providerId,
      'device_id': deviceId,
    };
  }
}
