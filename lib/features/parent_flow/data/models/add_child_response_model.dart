import 'package:lms/features/parent_flow/data/models/child_model.dart';

class AddChildResponseModel {
  final String message;
  final ChildModel child;

  AddChildResponseModel({required this.message, required this.child});

  factory AddChildResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle wrapped response: data, childData, or top-level fields
    Map<String, dynamic> childJson = {};
    if (json['data'] is Map) {
      childJson = json['data'];
    } else if (json['childData'] is Map) {
      childJson = json['childData'];
    } else {
      // Exclude message and success if child is top-level
      childJson = Map<String, dynamic>.from(json)..remove('message')..remove('success');
    }

    return AddChildResponseModel(
      message: json['message']?.toString() ?? 'تمت العملية بنجاح',
      child: ChildModel.fromJson(childJson),
    );
  }
}
