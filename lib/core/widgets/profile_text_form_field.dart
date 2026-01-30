import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';

class ProfileTextFormField extends StatefulWidget {
  const ProfileTextFormField({
    super.key,
    this.controller,
    this.onTapOutside,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.prefix,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final TapRegionCallback? onTapOutside;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final Widget? prefix;
  final bool readOnly;

  @override
  State<ProfileTextFormField> createState() => _ProfileTextFormFieldState();
}

class _ProfileTextFormFieldState extends State<ProfileTextFormField> {
  bool _isPasswordHidden = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: widget.readOnly,
      onTapOutside:
          widget.onTapOutside ??
          (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
      validator: widget.validator,
      obscureText: widget.isPassword ? _isPasswordHidden : false,
      keyboardType: widget.isPassword
          ? TextInputType.visiblePassword
          : widget.keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.cF0F3F6,
        prefixIcon: Builder(
          builder: (context) {
            if (widget.isPassword) {
              return GestureDetector(
                onTap: () {
                  _togglePasswordVisibility();
                },
                child: _isPasswordHidden
                    ? const Icon(Icons.visibility_off, color: AppColors.cADB3BC)
                    : const Icon(Icons.visibility, color: AppColors.cADB3BC),
              );
            }
            return widget.prefix ?? const SizedBox.shrink();
          },
        ),
        hint: widget.hintText != null
            ? Text(
                widget.hintText!,
                style: const TextStyle(
                  color: AppColors.c737373,
                  fontSize: 16.77,
                  fontWeight: FontWeight.w400,
                ),
              )
            : null,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(52.4),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(52.4),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(52.4),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(52.4),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
