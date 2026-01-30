import 'package:flutter/material.dart';
import 'package:lms/core/enums/toast_style_enum.dart';
import 'package:lms/core/enums/toast_type_enum.dart';
import 'package:lms/core/service/toast_service.dart';
import 'package:toastification/toastification.dart';

class ToastServiceImpl implements ToastService {
  @override
  void showToast(
    BuildContext context, {
    required String title,
    required ToastTypeEnum type,
    ToastStyleEnum style = ToastStyleEnum.minimal,
    String? description,
    AlignmentDirectional? alignment = AlignmentDirectional.bottomCenter,
    Duration closeAfter = const Duration(seconds: 3),
    bool dragToClose = true,
  }) {
    toastification.show(
      context: context,
      type: _getToastType(type),
      style: _getToastStyle(style),
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: alignment,
      autoCloseDuration: closeAfter,
      boxShadow: lowModeShadow,
      dragToClose: dragToClose,
    );
  }

  ToastificationType _getToastType(ToastTypeEnum toastType) {
    return switch (toastType) {
      ToastTypeEnum.info => ToastificationType.info,
      ToastTypeEnum.success => ToastificationType.success,
      ToastTypeEnum.warn => ToastificationType.warning,
      ToastTypeEnum.error => ToastificationType.error,
    };
  }

  ToastificationStyle _getToastStyle(ToastStyleEnum toastType) {
    return switch (toastType) {
      ToastStyleEnum.minimal => ToastificationStyle.minimal,
      ToastStyleEnum.fillColored => ToastificationStyle.fillColored,
      ToastStyleEnum.flatColored => ToastificationStyle.flatColored,
      ToastStyleEnum.flat => ToastificationStyle.flat,
      ToastStyleEnum.simple => ToastificationStyle.simple,
    };
  }
}
