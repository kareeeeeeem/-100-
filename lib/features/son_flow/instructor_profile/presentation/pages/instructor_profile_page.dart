import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_svgs.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';

class InstructorProfilePage extends StatelessWidget {
  const InstructorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: ProfileImageAndEdit(
                    imageSize: 150,
                    showEditIcon: false,
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'محمد الصعيدي',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: CustomContainer(
                        height: 110,
                        borderAlpha: 0.4,
                        borderWidth: 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            AppSvgs.book.svg(fit: BoxFit.scaleDown),
                            const Text(
                              '12',
                              style: TextStyle(
                                fontSize: 31.11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const Flexible(
                              child: Text(
                                'الدورات',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      child: CustomContainer(
                        height: 110,
                        borderAlpha: 0.4,
                        borderWidth: 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Icon(
                              Icons.people_outline,
                              color: AppColors.primary,
                            ),
                            Text(
                              '8000',
                              style: TextStyle(
                                fontSize: 31.11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'طالب',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomContainer(
                        height: 110,
                        borderAlpha: 0.4,
                        borderWidth: 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            AppSvgs.coin.svg(fit: BoxFit.scaleDown),
                            const Text(
                              '15+',
                              style: TextStyle(
                                fontSize: 31.11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const Flexible(
                              child: Text(
                                'عام من الخبرة',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'نبذة عن المعلم',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'بخبرة تزيد عن 15 عامًا في مجال التدريس، ساهم في توجيه آلاف الطلاب نحو التميز الأكاديمي وتحقيق أفضل النتائج. يعتمد في أسلوبه التعليمي على الجمع بين الأسس العلمية التقليدية والأساليب الحديثة، مما يجعل المفاهيم المعقدة أكثر وضوحًا وسهولة وتفاعلاً. حاصل على درجة الدكتوراه في تخصصه، كما نال عدة جوائز وشهادات تقدير نظير تميزه وإسهاماته في العملية التعليمية.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'مساعدو التدريس',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: CustomContainer(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ProfileImageAndEdit(
                                imageSize: 66,
                                showEditIcon: false,
                              ),
                              Text(
                                'محمد خالد',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'مساعد تدريس',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.c737373,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomContainer(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ProfileImageAndEdit(
                                imageSize: 66,
                                showEditIcon: false,
                              ),
                              Text(
                                'محمد خالد',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'مساعد تدريس',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.c737373,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'دورات ذات صلة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.pushNamed(AppRoutes.courseDetails);
                      },
                      child: CustomContainer(
                        borderRadius: 10,
                        borderAlpha: 0.4,
                        borderWidth: 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 10,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const Text(
                                'تصميم الواجهات',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemCount: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
