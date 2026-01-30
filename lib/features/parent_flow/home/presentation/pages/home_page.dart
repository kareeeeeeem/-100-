import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';
import 'package:lms/features/on_boarding/presentation/manger/my_courses_cubit.dart';
import 'package:lms/features/parent_flow/course/presentation/widgets/running_course_item_view.dart';
import 'package:lms/features/parent_flow/home/presentation/widgets/notifications_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // بروفايل الابن
                ProfileImageAndEdit(
                  imageSize: 150,
                  onEditTap: () {
                    context.pushNamed(AppRoutes.sonProfileDetails);
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'محمد الصعيدي',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),

                // قسم الإشعارات
                _buildNotificationTile(context),
                const SizedBox(height: 20),

                // عنوان قسم الدورات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الدورات الخاصة بالابن',
                      style: TextStyle(fontSize: 18.66, fontWeight: FontWeight.w700, color: AppColors.c303030),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Text('عرض المزيد', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // --- هذا هو الجزء الديناميكي الصحيح ---
                BlocBuilder<MyCoursesCubit, MyCoursesState>(
                  builder: (context, state) {
                    if (state.status == MyCoursesStatus.loading) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (state.status == MyCoursesStatus.success) {
                      final courses = state.courses ?? [];
                      if (courses.isEmpty) {
                        return const Center(child: Text("لا توجد دورات حالياً"));
                      }
                      return CustomContainer(
                        borderAlpha: 0.5,
                        borderWidth: 0.4,
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            return RunningCourseItemView(courseItem: courses[index]);
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: AppColors.c737373.withOpacity(0.5),
                          ),
                        ),
                      );
                    } else if (state.status == MyCoursesStatus.error) {
                      return Center(child: Text(state.errorMessage ?? "حدث خطأ ما"));
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // ---------------------------------------

                const SizedBox(height: 20),

                // أزرار التحكم
                _buildActionTile(
                  context,
                  title: 'تعديل بيانات الابن',
                  onTap: () => context.pushNamed(AppRoutes.sonProfileDetailsParent),
                ),
                const SizedBox(height: 10),
                _buildActionTile(
                  context,
                  title: 'عرض نتائج الابن',
                  onTap: () => context.pushNamed(AppRoutes.sonExamResults),
                ),
                const SizedBox(height: 10),
                _buildActionTile(
                  context,
                  title: 'اضافة ابن جديد',
                  onTap: () => context.pushNamed(AppRoutes.addNewSon),
                ),
                const SizedBox(height: 10),
                _buildActionTile(
                  context,
                  title: 'طلبات الدفع',
                  onTap: () => context.pushNamed(AppRoutes.paymentRequests),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (context) => SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: const NotificationsBottomSheet(),
          ),
        );
      },
      child: CustomContainer(
        borderRadius: 10,
        borderAlpha: 0.4,
        borderWidth: 0.3,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الاشعارات', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              Icon(Icons.notifications, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: CustomContainer(
        borderRadius: 10,
        borderAlpha: 0.4,
        borderWidth: 0.3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AppImages.parentSectionItem.image(width: 60, height: 60),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}