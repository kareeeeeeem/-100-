import 'package:flutter/material.dart';
import 'package:lms/core/enums/toast_style_enum.dart';
import 'package:lms/core/enums/toast_type_enum.dart';

abstract class ToastService {
  void showToast(
    BuildContext context, {
    required String title,
    required ToastTypeEnum type,
    ToastStyleEnum style = ToastStyleEnum.minimal,
    String? description,
    AlignmentDirectional? alignment = AlignmentDirectional.bottomCenter,
    Duration closeAfter = const Duration(seconds: 3),
    bool dragToClose = true,
  });
}
