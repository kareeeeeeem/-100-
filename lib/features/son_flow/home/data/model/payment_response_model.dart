class PaymentResponseModel {
  final bool success;
  final String? redirectUrl;
  final String? status;
  final String? message;

  PaymentResponseModel({
    required this.success,
    this.redirectUrl,
    this.status,
    this.message,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      success: json['success'] ?? false,
      redirectUrl: json['redirect_url']?.toString(),
      status: json['status']?.toString(),
      message: json['message']?.toString(),
    );
  }
}
