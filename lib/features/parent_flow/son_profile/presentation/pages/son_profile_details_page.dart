import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';
import 'package:lms/core/widgets/profile_text_form_field.dart';

class SonProfileDetailsPage extends StatelessWidget {
  const SonProfileDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بيانات الابن')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ProfileImageAndEdit(imageSize: 121.5, showEditIcon: false),
            const SizedBox(height: 30),
            const ProfileTextFormField(
              hintText: 'احمد حاتم',
              readOnly: true,
              prefix: Icon(Icons.person, color: AppColors.cADB3BC),
            ),
            const SizedBox(height: 20),
            const ProfileTextFormField(
              hintText: 'ahmed@gmail.com',
              readOnly: true,
              prefix: Icon(Icons.email, color: AppColors.cADB3BC),
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
                context.pushNamed(AppRoutes.editProfileDetailsParent);
              },
            ),
          ],
        ),
      ),
    );
  }
}
