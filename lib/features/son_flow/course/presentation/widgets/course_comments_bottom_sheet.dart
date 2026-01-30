import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_text_form_field.dart';

class CourseCommentsBottomSheet extends StatelessWidget {
  const CourseCommentsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            spacing: 10,
            children: [
              const Text(
                'التعليقات',
                style: TextStyle(
                  fontSize: 20.96,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Text(
                '102K',
                style: TextStyle(
                  fontSize: 14.67,
                  fontWeight: FontWeight.w400,
                  color: AppColors.cAAAAAA,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  context.pop();
                },
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.c737373.withValues(alpha: 0.4)),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemBuilder: (context, index) {
              return Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppImages.blackWhite.image(width: 24, height: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            const Text(
                              'احمد حاتم .',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'منذ 7 دقائق',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.c737373.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'هل سيحل الذكاء الاصطناعي محل مهارات ووظائف مصممي واجهة المستخدم وتجربة المستخدم إذا ما أخذوا بعين الاعتبار؟',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.c111111,
                          ),
                          child: Row(
                            spacing: 10,
                            children: [
                              Row(
                                spacing: 4,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('632'),
                                  Icon(
                                    Icons.thumb_down_alt_outlined,
                                    color: AppColors.c111111,
                                    size: 14,
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 4,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('1.7 K'),
                                  Icon(
                                    Icons.thumb_up_alt_outlined,
                                    color: AppColors.c111111,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text(
                                '470 من الردود',
                                style: TextStyle(
                                  fontSize: 14.67,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 14);
            },
            itemCount: 5,
          ),
        ),
        Container(
          color: AppColors.primary,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 10,
              children: [
                AppImages.blackWhite.image(width: 24, height: 24),
                Expanded(
                  child: CustomTextFormField(
                    fillColor: Colors.white,
                    hintText: 'اضف تعليق',
                    onTapOutside: (_) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
