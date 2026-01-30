import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
class RunningCourseItemView extends StatelessWidget {
  // إضافة المتغيرات لاستقبال الداتا
  final String courseName;
  final String? instructorName;
  final String? lessonsAndHours;
  final double progress;
  final String? imageUrl;

  const RunningCourseItemView({
    super.key,
    required this.courseName,
    this.instructorName,
    this.lessonsAndHours,
    required this.progress,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        spacing: 10,
        children: [
          // عرض الصورة من الـ Network أو لون أسود كـ Placeholder
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              image: imageUrl != null
                  ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                  : null,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 10,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // عشان الكلام يبدأ من اليمين صح
                      spacing: 4,
                      children: [
                        Text(
                          courseName, // اسم الكورس الحقيقي
                          style: const TextStyle(
                            fontSize: 13.32,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          lessonsAndHours ?? '', // عدد الدروس والساعات
                          style: const TextStyle(
                            fontSize: 9.52,
                            color: AppColors.c737373,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        context.pushNamed(AppRoutes.subscribedCourseDetails);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'استكمال',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                LinearProgressIndicator(
                  value: progress, // نسبة التقدم الحقيقية (من 0.0 لـ 1.0)
                  color: AppColors.c589B6E,
                  minHeight: 9,
                  backgroundColor: AppColors.cD9D9D9,
                  borderRadius: BorderRadius.circular(6.47),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}