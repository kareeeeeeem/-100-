import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_colors.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    this.controller,
    this.onTapOutside,
    this.hintText,
    this.validator,
    this.visibleWidget,
    this.hiddenWidget,
  });

  final TextEditingController? controller;
  final TapRegionCallback? onTapOutside;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final Widget? visibleWidget;
  final Widget? hiddenWidget;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _isPasswordHidden = true;

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onTapOutside:
          widget.onTapOutside ??
          (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'كلمة المرور مطلوبة';
            } else if (value.length < 8) {
              return 'يجب أن تكون كلمة المرور على الأقل 8 أحرف';
            }
            return null;
          },
      obscureText: _isPasswordHidden,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.cF6F7FA,
        suffixIcon: _isPasswordHidden
            ? GestureDetector(
                onTap: () {
                  togglePasswordVisibility();
                },
                child:
                    widget.hiddenWidget ??
                    const Icon(Icons.visibility_off, color: AppColors.c9D9FA0),
              )
            : GestureDetector(
                onTap: () {
                  togglePasswordVisibility();
                },
                child:
                    widget.visibleWidget ??
                    const Icon(Icons.visibility, color: AppColors.c9D9FA0),
              ),
        hint: widget.hintText != null
            ? Text(
                widget.hintText!,
                style: const TextStyle(
                  color: AppColors.c9D9FA0,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              )
            : const Text(
                'كلمة السر',
                style: TextStyle(
                  color: AppColors.c9D9FA0,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
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
