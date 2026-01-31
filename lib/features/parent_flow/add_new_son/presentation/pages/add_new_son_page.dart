import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';
import 'package:lms/core/widgets/profile_text_form_field.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_cubit.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';

class AddNewSonPage extends StatefulWidget {
  const AddNewSonPage({super.key});

  @override
  State<AddNewSonPage> createState() => _AddNewSonPageState();
}

class _AddNewSonPageState extends State<AddNewSonPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _identityNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _identityNumberController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'identity_number': _identityNumberController.text.trim(),
      };
      
      context.read<ParentCubit>().addChild(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اضافة ابن جديد')),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {
          if (state.status == ParentStatus.childAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إضافة الابن بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state.status == ParentStatus.error) {
            String message = state.errorMessage ?? 'حدث خطأ ما';
            if (message.contains('validation.exists')) {
              message = 'البريد الإلكتروني أو الهاتف أو الرقم القومي مسجل مسبقاً';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == ParentStatus.loading;
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileImageAndEdit(imageSize: 121.5, onEditTap: () {}),
                    const SizedBox(height: 30),
                    ProfileTextFormField(
                      controller: _nameController,
                      hintText: 'الاسم الكامل',
                      prefix: const Icon(Icons.person, color: AppColors.cADB3BC),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _emailController,
                      hintText: 'البريد الإلكتروني',
                      prefix: const Icon(Icons.email, color: AppColors.cADB3BC),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'البريد الإلكتروني غير صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _phoneController,
                      hintText: 'رقم الهاتف',
                      prefix: const Icon(Icons.phone, color: AppColors.cADB3BC),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _identityNumberController,
                      hintText: 'الرقم القومي',
                      prefix: const Icon(Icons.badge, color: AppColors.cADB3BC),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال الرقم القومي';
                        }
                        if (value.length != 14) {
                          return 'الرقم القومي يجب أن يكون 14 رقم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _passwordController,
                      hintText: 'كلمة السر (8 أحرف على الأقل)',
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة السر';
                        }
                        if (value.length < 8) {
                          return 'كلمة السر يجب أن تكون 8 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      title: isLoading ? 'جاري الحفظ...' : 'حفظ',
                      onPressed: isLoading ? null : _handleSubmit,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
