import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/son_flow/payment/presentation/widgets/payment_bottom_sheet.dart';

class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الدورة '),
          actionsPadding: const EdgeInsetsDirectional.only(end: 16),
          actions: [
            InkWell(
              onTap: () {},
              child: const Icon(
                Icons.favorite_border,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height / 3,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(4.19, 8.38),
                        blurRadius: 14.67,
                        spreadRadius: 0.0,
                        color: const Color(0xFF000000).withValues(alpha: 0.15),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25.15),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(child: AppImages.live.image(fit: BoxFit.cover)),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.0),
                                Colors.black.withValues(alpha: 0.0),
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              stops: const [0.0, 0.0001, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'تصميم الخطوات السريعة للمبتدئين',
                  style: TextStyle(
                    fontSize: 18.86,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  spacing: 6,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.black.withValues(alpha: 0.7),
                      size: 16,
                    ),
                    Text(
                      '5h 21m',
                      style: TextStyle(
                        fontSize: 10.48,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '6 دروس',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.c589B6E,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'مجانا',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.c589B6E,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'تصميم واجهات',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'في هذه الدورة سأوضح العملية خطوة بخطوة، يوماً بيوماً، لبناء منتجات أفضل، تماماً كما تفعل جوجل، وسلاك، وكي إل إم، والعديد من الشركات الأخرى.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    context.pushNamed(AppRoutes.instructorProfile);
                  },
                  child: Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 41.92,
                        height: 41.92,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const CircleAvatar(
                          backgroundColor: Colors.black,
                        ),
                      ),
                      const Column(
                        children: [
                          Text(
                            'لوريل سيلها',
                            style: TextStyle(
                              fontSize: 16.77,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'مصمم منتجات',
                            style: TextStyle(
                              fontSize: 10.48,
                              fontWeight: FontWeight.w500,
                              color: AppColors.c9D9FA0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cF6F7FA,
                    borderRadius: BorderRadius.circular(8.39),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: 70.3,
                              height: 70.3,
                              child: Stack(
                                children: [
                                  AppImages.courseVideoThumbnail.image(
                                    width: 70.3,
                                    height: 70.3,
                                  ),
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Flexible(
                              child: Column(
                                spacing: 6,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'كيفية الحصول على تعليقات حول منتجاتهم في غضون 5 أيام فقط',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '04:10m',
                                    style: TextStyle(
                                      fontSize: 14.69,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.c8C8C8C,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 30);
                      },
                      itemCount: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomElevatedButton(
            title: 'احجز الان',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.9,
                    child: const PaymentBottomSheet(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
