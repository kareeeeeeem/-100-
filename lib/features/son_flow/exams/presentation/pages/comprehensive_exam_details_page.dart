import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';

class ComprehensiveExamDetailsPage extends StatelessWidget {
  const ComprehensiveExamDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  height: MediaQuery.sizeOf(context).width * 0.6,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: AppColors.primary),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'الاختبار الشامل تصميم الواجهات',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomElevatedButton(
                  title: 'ابدأ',
                  onPressed: () {
                    context.pushNamed(AppRoutes.comprehensiveExam);
                  },
                  isExpanded: false,
                  width: MediaQuery.sizeOf(context).width * 0.6,
                ),
                const SizedBox(height: 30),
                const Text.rich(
                  TextSpan(
                    text: 'مدة الاختبار: ',
                    children: [
                      TextSpan(
                        text: '10 دقائق',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'عدد الأسئلة: 10 أسئلة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'نوع الأسئلة: اختيار متعدد',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
