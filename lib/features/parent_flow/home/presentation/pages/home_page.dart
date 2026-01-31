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
import 'package:lms/features/parent_flow/presentation/manager/parent_cubit.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ParentCubit>();
    cubit.getProfile();
    cubit.getChildren();
    cubit.getParentCourses();
    cubit.getLiveSessions();
  }

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
                BlocBuilder<ParentCubit, ParentState>(
                  builder: (context, state) {
                    if (state.status == ParentStatus.loading && state.profile == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.profile != null) {
                      final profile = state.profile!;
                      return Column(
                        children: [
                          ProfileImageAndEdit(
                            imageSize: 150,
                            imagePath: profile.image,
                            onEditTap: () {
                              // context.pushNamed(AppRoutes.editProfileDetailsParent); // Use appropriate route if exists
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            profile.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      );
                    }
                    if (state.status == ParentStatus.error) {
                      return Text(state.errorMessage ?? 'Unknown Error');
                    }
                    return const SizedBox(); // Fallback
                  },
                ),
                const SizedBox(height: 20),

                // قسم الإشعارات
                _buildNotificationTile(context),
                const SizedBox(height: 20),

                // البثوث المباشرة
                BlocBuilder<ParentCubit, ParentState>(
                  builder: (context, state) {
                    if (state.liveSessions.isNotEmpty) {
                      return Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                'البثوث المباشرة',
                                style: TextStyle(fontSize: 18.66, fontWeight: FontWeight.w700, color: AppColors.c303030),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 180,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.liveSessions.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final session = state.liveSessions[index];
                                return Container(
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        child: Image.network(
                                          session['thumbnail'] ?? '',
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Container(height: 120, color: Colors.grey[200], child: const Icon(Icons.error)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          session['title'] ?? 'No Title',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),

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
                BlocBuilder<ParentCubit, ParentState>(
                  builder: (context, state) {
                    if (state.status == ParentStatus.loading && state.courses.isEmpty) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    final courses = state.courses;
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
                  },
                ),
                // ---------------------------------------

                const SizedBox(height: 20),

                // أزرار التحكم
                _buildActionTile(
                  context,
                  title: 'تعديل بيانات الابن',
                  onTap: () {
                    final state = context.read<ParentCubit>().state;
                    if (state.children.isNotEmpty) {
                      final child = state.children.first;
                      context.pushNamed(AppRoutes.editProfileDetailsParent, extra: child.id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('لا توجد بيانات للأبناء')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                _buildActionTile(
                  context,
                  title: 'عرض نتائج الابن',
                  onTap: () {
                    final state = context.read<ParentCubit>().state;
                    if (state.children.isNotEmpty) {
                      final child = state.children.first;
                      context.pushNamed(AppRoutes.sonExamResults, extra: child.id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('لا توجد بيانات للأبناء')),
                      );
                    }
                  },
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
                const SizedBox(height: 10),
                _buildActionTile(
                  context,
                  title: 'تسجيل الخروج',
                  onTap: () {
                    context.read<ParentCubit>().logout();
                    context.goNamed(AppRoutes.login);
                  },
                  isLogout: true,
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
        final parentCubit = context.read<ParentCubit>();
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (context) => BlocProvider.value(
            value: parentCubit,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.7,
              child: const NotificationsBottomSheet(),
            ),
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

  Widget _buildActionTile(BuildContext context, {required String title, required VoidCallback onTap, bool isLogout = false}) {
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
                child: AppImages.parentSectionItem.image(
                  width: 60,
                  height: 60,
                  color: isLogout ? Colors.red.withOpacity(0.1) : null,
                  colorBlendMode: isLogout ? BlendMode.srcIn : null,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isLogout ? Colors.red : Colors.black,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: isLogout ? Colors.red : Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}