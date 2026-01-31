// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_child_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddChildResponseModel _$AddChildResponseModelFromJson(
  Map<String, dynamic> json,
) => AddChildResponseModel(
  message: json['message'] as String,
  child: ChildModel.fromJson(json['child'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AddChildResponseModelToJson(
  AddChildResponseModel instance,
) => <String, dynamic>{'message': instance.message, 'child': instance.child};
