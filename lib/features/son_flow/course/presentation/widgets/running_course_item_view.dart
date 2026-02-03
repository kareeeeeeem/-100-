import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_image.dart';

class RunningCourseItemView extends StatelessWidget {
  final String courseName;
  final String? instructorName;
  final String? category;
  final String? lessonsAndHours;
  final double progress;
  final dynamic courseId;
  final String? imageUrl;

  const RunningCourseItemView({
    super.key,
    required this.courseName,
    this.instructorName,
    this.category,
    this.lessonsAndHours,
    required this.progress,
    required this.courseId,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomImage(
              imagePath: imageUrl ?? '',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 8,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Text(
                            courseName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (instructorName != null && instructorName!.isNotEmpty)
                            Text(
                              'المحاضر: $instructorName',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          Row(
                            children: [
                              Text(
                                lessonsAndHours ?? '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.c737373,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (category != null && category!.isNotEmpty) ...[
                                const Text(' | ', style: TextStyle(fontSize: 10, color: AppColors.cD9D9D9)),
                                Text(
                                  category!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.subscribedCourseDetails,
                          extra: int.tryParse(courseId.toString()) ?? courseId,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Text(
                            'استكمال',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                LinearProgressIndicator(
                  value: progress,
                  color: AppColors.c589B6E,
                  minHeight: 8,
                  backgroundColor: AppColors.cD9D9D9,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}