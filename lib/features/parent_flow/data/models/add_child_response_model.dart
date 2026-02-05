import 'package:lms/features/parent_flow/data/models/child_model.dart';

class AddChildResponseModel {
  final String message;
  final ChildModel child;

  AddChildResponseModel({required this.message, required this.child});

  factory AddChildResponseModel.fromJson(Map<String, dynamic> json) {
    return AddChildResponseModel(
      message: json['message']?.toString() ?? 'تمت العملية بنجاح',
      child: ChildModel.fromJson(json['data'] is Map ? json['data'] : {}),
    );
  }
}
