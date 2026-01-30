import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart'; 

class RunningCourseItemView extends StatelessWidget {
  // لازم نستقبل الـ Item عشان ناخد منه الـ ID والعنوان الحقيقي
  final MyCourseItemModel courseItem; 

  const RunningCourseItemView({super.key, required this.courseItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courseItem.title ?? 'بدون عنوان', // عنوان حقيقي من الـ API
                          style: const TextStyle(fontSize: 13.32, fontWeight: FontWeight.w500),
                        ),
                        const Text(
                          '6 دروس . 5 ساعات',
                          style: TextStyle(fontSize: 9.52, color: AppColors.c737373),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        // هنا بنبعت الـ ID لصفحة الفيديو
                        context.pushNamed(
                          AppRoutes.subscribedCourseDetails,
                          extra: courseItem.id, 
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'استكمال',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.5,
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