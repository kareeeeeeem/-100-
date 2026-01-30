import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_container.dart';

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'الامتحانات',
                  style: TextStyle(
                    fontSize: 25.15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.c111111,
                  ),
                ),
                const SizedBox(height: 30),
                ...List.generate(10, (index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          context.pushNamed(AppRoutes.prefaceExamDetails);
                        },
                        child: const CustomContainer(
                          borderRadius: 8,
                          borderWidth: 0.5,
                          borderAlpha: 0.7,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'امتحان تمهيدي علي الفصل الأول : من بداية الباب حتي نهاية استخدامات عناصر السلسلة الانتقالية الاولي ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  );
                }),
                InkWell(
                  onTap: () {
                    context.pushNamed(AppRoutes.comprehensiveExamDetails);
                  },
                  child: const CustomContainer(
                    borderRadius: 8,
                    borderWidth: 0.5,
                    borderAlpha: 0.7,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'امتحان تمهيدي علي الفصل الأول : من بداية الباب حتي نهاية استخدامات عناصر السلسلة الانتقالية الاولي ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
