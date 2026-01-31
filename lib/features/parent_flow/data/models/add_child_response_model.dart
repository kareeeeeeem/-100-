import 'package:lms/features/parent_flow/data/models/child_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_child_response_model.g.dart';

@JsonSerializable()
class AddChildResponseModel {
  final String message;
  final ChildModel child;

  AddChildResponseModel({required this.message, required this.child});

  factory AddChildResponseModel.fromJson(Map<String, dynamic> json) => _$AddChildResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddChildResponseModelToJson(this);
}
