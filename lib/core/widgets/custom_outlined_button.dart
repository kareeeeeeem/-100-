import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_fonts.dart';

final customOutlinedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  side: const BorderSide(width: 1, color: Colors.black),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.39)),
);

const customOutlinedButtonTitleStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.w500,
  fontFamily: AppFonts.cairo,
);

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    this.title,
    this.titleStyle,
    this.onPressed,
    this.buttonStyle,
    this.height,
    this.width,
    this.isExpanded = true,
  }) : child = null;

  const CustomOutlinedButton.child({
    super.key,
    this.onPressed,
    this.buttonStyle,
    this.height,
    this.width,
    this.isExpanded = true,
    this.child,
  }) : title = null,
       titleStyle = null;

  final String? title;
  final TextStyle? titleStyle;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final bool isExpanded;
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
      child: OutlinedButton(
        onPressed: onPressed,
        style: buttonStyle ?? customOutlinedButtonStyle,
        child: Builder(
          builder: (context) {
            if (title != null) {
              return Text(
                title!,
                style: titleStyle ?? customOutlinedButtonTitleStyle,
              );
            }
            return child!;
          },
        ),
      ),
    );
  }
}
