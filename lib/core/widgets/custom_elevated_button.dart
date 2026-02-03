import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_fonts.dart';

final customElevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: AppColors.primary,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.39)),
);

const customElevatedButtonTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w500,
  fontFamily: AppFonts.cairo,
);

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.title,
    this.titleStyle,
    this.onPressed,
    this.buttonStyle,
    this.height,
    this.width,
    this.isExpanded = true,
    this.isLoading = false,
  }) : child = null;

  const CustomElevatedButton.child({
    super.key,
    this.onPressed,
    this.buttonStyle,
    this.height,
    this.width,
    this.isExpanded = true,
    this.isLoading = false,
    this.child,
  }) : title = null,
       titleStyle = null;

  final String? title;
  final TextStyle? titleStyle;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final bool isExpanded;
  final bool isLoading;
  final double? height;
  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: isExpanded ? double.infinity : width ?? 0,
        minHeight: height ?? 58.76,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle ?? customElevatedButtonStyle,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Builder(
                builder: (context) {
                  if (title != null) {
                    return Text(
                      title!,
                      style: titleStyle ?? customElevatedButtonTitleStyle,
                    );
                  }
                  return child!;
                },
              ),
      ),
    );
  }
}
