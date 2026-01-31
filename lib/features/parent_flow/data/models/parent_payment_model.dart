import 'package:json_annotation/json_annotation.dart';

part 'parent_payment_model.g.dart';

@JsonSerializable()
class ParentPaymentResponseModel {
  final bool success;
  final String message;
  final List<ParentPaymentModel> data;

  ParentPaymentResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ParentPaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ParentPaymentResponseModelFromJson(json);
}

@JsonSerializable()
class ParentPaymentModel {
  @JsonKey(name: 'order_id')
  final int orderId;
  final String amount;
  @JsonKey(name: 'payment_gateway')
  final String? paymentGateway;
  final String status;
  @JsonKey(name: 'course_title')
  final String? courseTitle;
  @JsonKey(name: 'course_id')
  final int? courseId;
  @JsonKey(name: 'son_name')
  final String? sonName;

  ParentPaymentModel({
    required this.orderId,
    required this.amount,
    this.paymentGateway,
    required this.status,
    this.courseTitle,
    this.courseId,
    this.sonName,
  });

  factory ParentPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$ParentPaymentModelFromJson(json);
}
