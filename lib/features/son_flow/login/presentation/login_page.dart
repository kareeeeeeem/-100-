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
import 'package:lms/features/son_flow/login/presentation/manager/login_cubit.dart';
import 'package:lms/features/son_flow/login/presentation/manager/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _fromKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fromKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) {
        return previous.loginStatus != current.loginStatus;
      },
    listener: (context, state) {
  if (state.loginStatus == RequestStatus.loading) {
    context.showLoading();
  } else if (state.loginStatus == RequestStatus.success) {
    context.hidLoading();

    final type = state.userType?.toLowerCase();

    // هنا استخدمت مسميات المسارات اللي في ملف الـ AppRouter بتاعك بالضبط
    switch (type) {
      case 'parent':
        context.go(AppRoutes.parentHome); // يفتح الهوم بتاعة ولي الأمر
        break;
      case 'student':
        context.go(AppRoutes.sonHome); // يفتح الهوم بتاعة الطالب (HomeLayout)
        break;
      default:
        // أي دور تاني (محاسب/أدمن) حالياً يروح لهوم الطالب لغاية ما تكريه صفحاتهم
        context.go(AppRoutes.sonHome); 
    }

    context.showSuccessToast(title: 'تم تسجيل الدخول بنجاح');
  } else if (state.loginStatus == RequestStatus.error) {
    context.hidLoading();
    context.showErrorToast(
      title: state.loginErrorMessage ?? 'خطأ في تسجيل الدخول',
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
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppImages.logo.image(width: 140, height: 69),
                      CustomTextFormField(
                        hintText: 'البريد الالكتروني',
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'البريد الالكتروني مطلوب';
                          } else if (!AppConstants.emailRegex.hasMatch(value)) {
                            return 'البريد الإلكتروني غير صالح';
                          }
                          return null;
                        },
                      ),
                      PasswordTextFormField(controller: _passwordController),
                      CustomElevatedButton(
                        title: 'تسجيل الدخول',
                        onPressed: () {
                          if (_fromKey.currentState!.validate()) {
                            context.read<LoginCubit>().login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          'نسيت كلمة السر؟',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.c0082CD,
                          ),
                        ),
                      ),
                      const Row(
                        spacing: 20,
                        children: [
                          Expanded(
                            child: Divider(height: 1, color: AppColors.cC7C9D9),
                          ),
                          Text(
                            'او',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.c8C8C8C,
                            ),
                          ),
                          Expanded(
                            child: Divider(height: 1, color: AppColors.cC7C9D9),
                          ),
                        ],
                      ),
                      CustomElevatedButton.child(
                        onPressed: () {},
                        buttonStyle: customElevatedButtonStyle.copyWith(
                          backgroundColor: const WidgetStatePropertyAll(
                            AppColors.c0082CD,
                          ),
                        ),
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImages.facebook.image(width: 24, height: 24),
                            const Flexible(
                              child: Text(
                                'تسجيل الدخول بواسطة فيسبوك',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomElevatedButton.child(
                        onPressed: () {},
                        buttonStyle: customElevatedButtonStyle.copyWith(
                          backgroundColor: const WidgetStatePropertyAll(
                            AppColors.cF6F7FA,
                          ),
                        ),
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImages.google.image(width: 24, height: 24),
                            const Flexible(
                              child: Text(
                                'تسجيل الدخول بواسطة جوجل',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ليس لديك حساب ؟',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.c9D9FA0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context.go(AppRoutes.register);
                            },
                            child: const Text(
                              'انشاء حساب',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
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
