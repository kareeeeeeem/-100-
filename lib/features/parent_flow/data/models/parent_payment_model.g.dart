// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentPaymentResponseModel _$ParentPaymentResponseModelFromJson(
  Map<String, dynamic> json,
) => ParentPaymentResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => ParentPaymentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ParentPaymentResponseModelToJson(
  ParentPaymentResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

ParentPaymentModel _$ParentPaymentModelFromJson(Map<String, dynamic> json) =>
    ParentPaymentModel(
      orderId: (json['order_id'] as num).toInt(),
      amount: json['amount'] as String,
      paymentGateway: json['payment_gateway'] as String?,
      status: json['status'] as String,
      courseTitle: json['course_title'] as String?,
      courseId: (json['course_id'] as num?)?.toInt(),
      sonName: json['son_name'] as String?,
    );

Map<String, dynamic> _$ParentPaymentModelToJson(ParentPaymentModel instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'amount': instance.amount,
      'payment_gateway': instance.paymentGateway,
      'status': instance.status,
      'course_title': instance.courseTitle,
      'course_id': instance.courseId,
      'son_name': instance.sonName,
    };
