import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/core/enums/toast_style_enum.dart';
import 'package:lms/core/enums/toast_type_enum.dart';
import 'package:lms/core/service/toast_service.dart';

extension ToastExtension on BuildContext {
  static final ToastService _toastService = GetIt.instance<ToastService>();

  void showToast({
    required String title,
    required ToastTypeEnum type,
    ToastStyleEnum style = ToastStyleEnum.minimal,
    String? description,
    AlignmentDirectional? alignment = AlignmentDirectional.bottomCenter,
    Duration closeAfter = const Duration(seconds: 3),
    bool dragToClose = true,
  }) {
    _toastService.showToast(
      this,
      title: title,
      type: type,
      style: style,
      description: description,
      alignment: alignment,
      closeAfter: closeAfter,
      dragToClose: dragToClose,
    );
  }

  void showSuccessToast({
    required String title,
    ToastStyleEnum style = ToastStyleEnum.minimal,
    String? description,
    AlignmentDirectional? alignment = AlignmentDirectional.bottomCenter,
    Duration closeAfter = const Duration(seconds: 3),
    bool dragToClose = true,
  }) {
    _toastService.showToast(
      this,
      title: title,
      type: ToastTypeEnum.success,
      style: style,
      description: description,
      alignment: alignment,
      closeAfter: closeAfter,
      dragToClose: dragToClose,
    );
  }

  void showInfoToast({
    required String title,
    ToastStyleEnum style = ToastStyleEnum.minimal,
    String? description,
    AlignmentDirectional? alignment = AlignmentDirectional.bottomCenter,
    Duration closeAfter = const Duration(seconds: 3),
    bool dragToClose = true,
  }) {
    _toastService.showToast(
      this,
      title: title,
      type: ToastTypeEnum.info,
      style: style,
      description: description,
      alignment: alignment,
      closeAfter: closeAfter,
      dragToClose: dragToClose,
    );
  }

  void showWarnToast({
    required String title,
    ToastStyleEnum style = ToastStyleEnum.minimal,
    String? description,
    AlignmentDirectional? alignment = AlignmentDirectional.bottomCenter,
    Duration closeAfter = const Duration(seconds: 3),
    bool dragToClose = true,
  }) {
    _toastService.showToast(
      this,
      title: title,
      type: ToastTypeEnum.warn,
      style: style,
      description: description,
      alignment: alignment,
      closeAfter: closeAfter,
      dragToClose: dragToClose,
    );
  }

  void showErrorToast({
    required String title,
    ToastStyleEnum style = ToastStyleEnum.minimal,
    String? description,
    AlignmentDirectional? alignment = AlignmentDirectional.bottomCenter,
    Duration closeAfter = const Duration(seconds: 3),
    bool dragToClose = true,
  }) {
    _toastService.showToast(
      this,
      title: title,
      type: ToastTypeEnum.error,
      style: style,
      description: description,
      alignment: alignment,
      closeAfter: closeAfter,
      dragToClose: dragToClose,
    );
  }
}
