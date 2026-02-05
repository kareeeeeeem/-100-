import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart'; 
import 'package:lms/core/widgets/custom_image.dart';

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
          CustomImage(
            imagePath: courseItem.thumbnail,
            width: 52,
            height: 52,
            borderRadius: 10,
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
                        Text(
                          '${courseItem.lessonsCountText} دروس . ${courseItem.duration}',
                          style: const TextStyle(fontSize: 9.52, color: AppColors.c737373),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: (double.tryParse(courseItem.progressText) ?? 0) / 100,
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