import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/widgets/loading_widget.dart';

extension LoadingExtension on BuildContext {
  void showLoading({Widget? loadingWidget, bool canDismiss = false}) {
    showDialog(
      context: this,
      barrierDismissible: canDismiss,
      builder: (_) {
        return PopScope(
          canPop: canDismiss,
          child: Center(
            child: SizedBox(
              width: (60 * 2) + 2,
              height: (60 * 2) + 2,
              child: loadingWidget ?? const LoadingWidget(),
            ),
          ),
        );
      },
    );
  }

  void hidLoading() {
    pop();
  }
}
