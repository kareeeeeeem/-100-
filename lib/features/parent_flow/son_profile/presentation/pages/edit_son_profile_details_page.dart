import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/profile_text_form_field.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_cubit.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';

class EditSonProfileDetailsPage extends StatefulWidget {
  const EditSonProfileDetailsPage({super.key});

  @override
  State<EditSonProfileDetailsPage> createState() => _EditSonProfileDetailsPageState();
}

class _EditSonProfileDetailsPageState extends State<EditSonProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  int? _childId;
  bool _hasInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  void _initializeControllers(ParentState state) {
    if (!_hasInitialized && state.selectedChild != null) {
      _childId = state.selectedChild!.id;
      _nameController.text = state.selectedChild!.name;
      _emailController.text = state.selectedChild!.email;
      _phoneController.text = state.selectedChild!.phone ?? '';
      _hasInitialized = true;
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_childId != null) {
        final parentCubit = context.read<ParentCubit>();
        final currentChild = parentCubit.state.selectedChild;
        
        final data = <String, dynamic>{};
        
        final newName = _nameController.text.trim();
        final newEmail = _emailController.text.trim();
        final newPhone = _phoneController.text.trim();

        if (currentChild != null) {
          if (newName != currentChild.name) data['name'] = newName;
          if (newEmail != currentChild.email) data['email'] = newEmail;
          if (newPhone != (currentChild.phone ?? '')) data['phone'] = newPhone;
        } else {
          data['name'] = newName;
          data['email'] = newEmail;
          data['phone'] = newPhone;
        }

        // Only include password if it's provided
        if (_passwordController.text.isNotEmpty) {
          data['password'] = _passwordController.text;
          data['password_confirmation'] = _passwordConfirmationController.text;
        }

        if (data.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لم يتم إجراء أي تغييرات')),
          );
          return;
        }

        parentCubit.updateChild(_childId!, data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل بيانات الابن')),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {
          if (state.status == ParentStatus.childUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث البيانات بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state.status == ParentStatus.error) {
            String message = state.errorMessage ?? 'حدث خطأ ما';
            if (message.contains('validation.exists')) {
              message = 'البريد الإلكتروني أو الهاتف مسجل مسبقاً';
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
          _initializeControllers(state);

          if (state.status == ParentStatus.loading && !_hasInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          final isLoading = state.status == ParentStatus.loading;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileImageAndEdit(
                      imageSize: 121.5,
                      imagePath: state.selectedChild?.avatar,
                      onEditTap: () {},
                    ),
                    const SizedBox(height: 30),
                    ProfileTextFormField(
                      controller: _nameController,
                      hintText: 'الاسم',
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
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _passwordController,
                      hintText: 'كلمة السر الجديدة (اختياري)',
                      isPassword: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 8) {
                          return 'كلمة السر يجب أن تكون 8 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _passwordConfirmationController,
                      hintText: 'تأكيد كلمة السر الجديدة',
                      isPassword: true,
                      validator: (value) {
                        if (_passwordController.text.isNotEmpty) {
                          if (value != _passwordController.text) {
                            return 'كلمة السر غير متطابقة';
                          }
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
