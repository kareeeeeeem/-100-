import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';

class PaymentTextFormField extends StatelessWidget {
  const PaymentTextFormField({
    super.key,
    this.controller,
    this.onTapOutside,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
  });

  final TextEditingController? controller;
  final TapRegionCallback? onTapOutside;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (hintText != null)
          Text(
            hintText!,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            onTapOutside:
                onTapOutside ??
                (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
            validator: validator,
            obscureText: isPassword,
            keyboardType: isPassword
                ? TextInputType.visiblePassword
                : keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.c737373B2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.c737373B2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
