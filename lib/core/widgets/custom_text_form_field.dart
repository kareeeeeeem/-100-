import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.onTapOutside,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.prefix,
    this.suffix,
    this.fillColor,
  });

  final TextEditingController? controller;
  final TapRegionCallback? onTapOutside;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final Widget? prefix;
  final Widget? suffix;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTapOutside:
          onTapOutside ??
          (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
      validator: validator,
      obscureText: isPassword,
      keyboardType: isPassword ? TextInputType.visiblePassword : keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? AppColors.cF6F7FA,
        prefixIcon: prefix,
        suffixIcon: suffix,
        hint: hintText != null
            ? Text(
                hintText!,
                style: const TextStyle(
                  color: AppColors.c9D9FA0,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              )
            : null,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
