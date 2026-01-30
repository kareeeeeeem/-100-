import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';
import 'package:lms/core/widgets/profile_text_form_field.dart';

class AddNewSonPage extends StatelessWidget {
  const AddNewSonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اضافة ابن جديد')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileImageAndEdit(imageSize: 121.5, onEditTap: () {}),
              const SizedBox(height: 30),
              const ProfileTextFormField(
                hintText: 'احمد حاتم',
                prefix: Icon(Icons.person, color: AppColors.cADB3BC),
              ),
              const SizedBox(height: 20),
              const ProfileTextFormField(
                hintText: 'ahmed@gmail.com',
                prefix: Icon(Icons.email, color: AppColors.cADB3BC),
              ),
              const SizedBox(height: 20),
              const ProfileTextFormField(
                hintText: 'ادخل كلمة السر',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              const ProfileTextFormField(
                hintText: 'اعد ادخال كلمة السر',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                title: 'حفظ',
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
