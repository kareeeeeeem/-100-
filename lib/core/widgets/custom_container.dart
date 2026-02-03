import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.borderWidth = 0.5,
    this.borderAlpha = 0.5,
    this.height,
    this.color,
    this.borderRadius = 20,
    this.boxShadow,
    this.padding,
  });

  final Widget child;
  final Color? color;
  final double borderWidth;
  final double borderAlpha;
  final double? height;
  final double borderRadius;
  final BoxShadow? boxShadow;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.c737373.withValues(alpha: borderAlpha),
          width: borderWidth,
        ),
        boxShadow: [
          boxShadow ??
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 0,
                color: Colors.black.withValues(alpha: 0.25),
              ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}
