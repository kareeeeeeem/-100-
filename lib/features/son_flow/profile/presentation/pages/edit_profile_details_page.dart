import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/profile_text_form_field.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_state.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';

class EditProfileDetailsPage extends StatefulWidget {
  const EditProfileDetailsPage({super.key});

  @override
  State<EditProfileDetailsPage> createState() => _EditProfileDetailsPageState();
}

class _EditProfileDetailsPageState extends State<EditProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل معلومات الحساب')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            final data = state.profileModel.data;
            if (data != null) {
              // Always update controllers when ProfileSuccess is received
              _nameController.text = data.name ?? '';
              _emailController.text = data.email ?? '';
            }
          } else if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            // After a successful update, refresh the profile data to ensure UI consistency
            context.read<ProfileCubit>().getProfileData();
          } else if (state is ProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
          } else if (state is ChangePasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          ProfileData? userData;
          if (state is ProfileSuccess) {
            userData = state.profileModel.data;
          } else if (context.read<ProfileCubit>().state is ProfileSuccess) {
             userData = (context.read<ProfileCubit>().state as ProfileSuccess).profileModel.data;
          }

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
                      imagePath: userData?.image,
                      onEditTap: () {
                        // User requested to keep it personal/static for now
                      },
                    ),
                    const SizedBox(height: 30),
                    ProfileTextFormField(
                      controller: _nameController,
                      hintText: 'الاسم',
                      prefix: const Icon(Icons.person, color: AppColors.cADB3BC),
                      validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال الاسم' : null,
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _emailController,
                      hintText: 'البريد الإلكتروني',
                      prefix: const Icon(Icons.email, color: AppColors.cADB3BC),
                      validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال البريد الإلكتروني' : null,
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    const Text(
                      'تغيير كلمة السر',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _currentPasswordController,
                      hintText: 'ادخل كلمة السر الحالية',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _newPasswordController,
                      hintText: 'ادخل كلمة السر الجديدة',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    ProfileTextFormField(
                      controller: _confirmPasswordController,
                      hintText: 'اعد ادخال كلمة السر الجديدة',
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),
                    CustomElevatedButton(
                      title: 'حفظ',
                      isLoading: state is ProfileUpdateLoading || state is ChangePasswordLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Update profile data
                          context.read<ProfileCubit>().updateProfileData(
                            name: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                          );

                          // Change password if fields are not empty
                          if (_currentPasswordController.text.isNotEmpty ||
                              _newPasswordController.text.isNotEmpty ||
                              _confirmPasswordController.text.isNotEmpty) {
                            if (_newPasswordController.text != _confirmPasswordController.text) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('كلمات السر الجديدة غير متطابقة'), backgroundColor: Colors.orange),
                              );
                              return;
                            }
                            context.read<ProfileCubit>().changeProfilePassword(
                              currentPassword: _currentPasswordController.text,
                              newPassword: _newPasswordController.text,
                              confirmPassword: _confirmPasswordController.text,
                            );
                          }
                        }
                      },
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
