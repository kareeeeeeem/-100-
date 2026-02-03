import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/profile_text_form_field.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_state.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('معلومات الحساب')),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          if (state is ProfileSuccess) {
            final data = state.profileModel.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImageAndEdit(
                    imageSize: 121.5,
                    showEditIcon: false,
                    imagePath: data?.image,
                  ),
                  const SizedBox(height: 30),
                  ProfileTextFormField(
                    hintText: data?.name ?? 'اسم المستخدم',
                    readOnly: true,
                    prefix: const Icon(Icons.person, color: AppColors.cADB3BC),
                  ),
                  const SizedBox(height: 20),
                  ProfileTextFormField(
                    hintText: data?.email ?? 'البريد الإلكتروني',
                    readOnly: true,
                    prefix: const Icon(Icons.email, color: AppColors.cADB3BC),
                  ),
                  const SizedBox(height: 20),
                  const ProfileTextFormField(
                    hintText: '*****************',
                    readOnly: true,
                    prefix: Icon(Icons.visibility_off, color: AppColors.cADB3BC),
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    title: 'تعديل',
                    onPressed: () {
                      context.pushNamed(AppRoutes.editProfileDetails);
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
