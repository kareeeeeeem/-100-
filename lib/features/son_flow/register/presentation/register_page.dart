import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/constants/app_constants.dart';
import 'package:lms/core/enums/request_status_enum.dart';
import 'package:lms/core/extensions/loading_extension.dart';
import 'package:lms/core/extensions/toast_extension.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/custom_text_form_field.dart';
import 'package:lms/core/widgets/password_text_form_field.dart';
import 'package:lms/features/son_flow/register/presentation/manager/register_cubit.dart';
import 'package:lms/features/son_flow/register/presentation/manager/register_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fromKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedUserType = 'student';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (prev, current) {
        return prev.registerStatus != current.registerStatus;
      },
      listener: (context, state) {
        if (state.registerStatus == RequestStatus.loading) {
          context.showLoading();
        } else if (state.registerStatus == RequestStatus.success) {
          context.hidLoading();
          context.showSuccessToast(
            title: 'تم التسجيل بنجاح',
          );
          context.go(AppRoutes.login);
        } else if (state.registerStatus == RequestStatus.error) {
          context.hidLoading();
          context.showErrorToast(
            title: state.registerErrorMessage ?? 'حدث خطأ ما',
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _fromKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppImages.logo.image(width: 140, height: 69),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'الاسم بالكامل',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الاسم مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'البريد الالكتروني',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'البريد الالكتروني مطلوب';
                          } else if (!AppConstants.emailRegex.hasMatch(value)) {
                            return 'البريد الإلكتروني غير صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      PasswordTextFormField(controller: _passwordController),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'رقم الهاتف',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'رقم الهاتف مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('طالب'),
                              value: 'student',
                              groupValue: _selectedUserType,
                              onChanged: (value) => setState(() => _selectedUserType = value!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('ولي أمر'),
                              value: 'parent',
                              groupValue: _selectedUserType,
                              onChanged: (value) => setState(() => _selectedUserType = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        title: 'انشاء الحساب',
                        onPressed: () {
                          if (_fromKey.currentState!.validate()) {
                            context.read<RegisterCubit>().register(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              phone: _phoneController.text,
                              userType: _selectedUserType,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(child: Divider(height: 1, color: AppColors.cC7C9D9)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('او', style: TextStyle(fontSize: 16, color: AppColors.c8C8C8C)),
                          ),
                          Expanded(child: Divider(height: 1, color: AppColors.cC7C9D9)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton.child(
                        onPressed: () {},
                        buttonStyle: customElevatedButtonStyle.copyWith(
                          backgroundColor: const WidgetStatePropertyAll(AppColors.c0082CD),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImages.facebook.image(width: 24, height: 24),
                            const SizedBox(width: 10),
                            const Text('تسجيل الدخول بواسطة فيسبوك', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton.child(
                        onPressed: () {},
                        buttonStyle: customElevatedButtonStyle.copyWith(
                          backgroundColor: const WidgetStatePropertyAll(AppColors.cF6F7FA),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImages.google.image(width: 24, height: 24),
                            const SizedBox(width: 10),
                            const Text('تسجيل الدخول بواسطة جوجل', style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: 'بالتسجيل، أنت توافق على ',
                          children: [
                            TextSpan(
                              text: 'شروط الخدمة وسياسة الخصوصية',
                              style: const TextStyle(color: AppColors.primary),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('لديك حساب ؟', style: TextStyle(fontSize: 16, color: AppColors.c9D9FA0)),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => context.go(AppRoutes.login),
                            child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}