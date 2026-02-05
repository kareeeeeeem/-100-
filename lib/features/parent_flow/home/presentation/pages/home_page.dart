import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/core/widgets/custom_image.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';
import 'package:lms/features/parent_flow/course/presentation/widgets/running_course_item_view.dart';
import 'package:lms/features/parent_flow/home/presentation/widgets/notifications_bottom_sheet.dart';
import 'package:lms/features/parent_flow/home/presentation/widgets/child_card.dart';
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
                // بروفايل ولي الأمر
                BlocBuilder<ParentCubit, ParentState>(
                  builder: (context, state) {
                    if (state.status == ParentStatus.loading && state.profile == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.profile != null) {
                      final profile = state.profile!;
                      return Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CustomImage(
                              imagePath: profile.image,
                              fit: BoxFit.cover,
                              isUserProfile: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            profile.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 20),

                // قسم أبنائي
                BlocBuilder<ParentCubit, ParentState>(
                  builder: (context, state) {
                    if (state.status == ParentStatus.loading && state.children.isEmpty) {
                      return const SizedBox();
                    }
                    if (state.children.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'أبنائي',
                            style: TextStyle(
                              fontSize: 18.66,
                              fontWeight: FontWeight.w700,
                              color: AppColors.c303030,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 110,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.children.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 15),
                              itemBuilder: (context, index) {
                                final child = state.children[index];
                                return ChildCard(
                                  child: child,
                                  onTap: () async {
                                    await context.pushNamed(
                                      AppRoutes.sonProfileDetailsParent,
                                      extra: child.id,
                                    );
                                    if (context.mounted) {
                                      final cubit = context.read<ParentCubit>();
                                      cubit.getChildren();
                                      cubit.getParentCourses();
                                    }
                                  },
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

                // قسم الإشعارات
                _buildNotificationTile(context),
                const SizedBox(height: 20),

                // البثوث المباشرة
                BlocBuilder<ParentCubit, ParentState>(
                  builder: (context, state) {
                    if (state.liveSessions.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'البثوث المباشرة',
                            style: TextStyle(fontSize: 18.66, fontWeight: FontWeight.w700, color: AppColors.c303030),
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
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Image.network(
                                          session['thumbnail'] ?? '',
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Container(height: 120, color: Colors.grey[100], child: const Icon(Icons.live_tv)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          session['title'] ?? 'بث مباشر جديد',
                                          maxLines: 1,
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
                      'الدورات الخاصة بالابناء',
                      style: TextStyle(fontSize: 18.66, fontWeight: FontWeight.w700, color: AppColors.c303030),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // الدورات
                BlocBuilder<ParentCubit, ParentState>(
                  builder: (context, state) {
                    if (state.status == ParentStatus.loading && state.courses.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.courses.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text("لا توجد دورات حالياً"),
                        ),
                      );
                    }
                    return CustomContainer(
                      borderRadius: 12,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.courses.length,
                        itemBuilder: (context, index) => RunningCourseItemView(courseItem: state.courses[index]),
                        separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.2)),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 25),

                // أزرار التحكم المعدلة بالأيقونات
                // _buildActionTile(
                //   context,
                //   title: 'تعديل بيانات الابن',
                //   icon: Icons.edit_note_rounded,
                //   iconColor: Colors.blue,
                //   onTap: () async {
                //     final cubit = context.read<ParentCubit>();
                //     final state = cubit.state;
                //     if (state.children.isNotEmpty) {
                //       await context.pushNamed(AppRoutes.editProfileDetailsParent, extra: state.children.first.id);
                //       if (context.mounted) {
                //         cubit.getChildren();
                //         cubit.getParentCourses();
                //       }
                //     }
                //   },
                // ),
                const SizedBox(height: 12),
                _buildActionTile(
                  context,
                  title: 'عرض نتائج الابن',
                  icon: Icons.analytics_rounded,
                  iconColor: Colors.orange,
                  onTap: () {
                    final state = context.read<ParentCubit>().state;
                    if (state.children.isNotEmpty) {
                      context.pushNamed(AppRoutes.sonExamResults, extra: state.children.first.id);
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildActionTile(
                  context,
                  title: 'إضافة ابن جديد',
                  icon: Icons.person_add_alt_1_rounded,
                  iconColor: Colors.green,
                  onTap: () async {
                    await context.pushNamed(AppRoutes.addNewSon);
                    if (context.mounted) {
                      final cubit = context.read<ParentCubit>();
                      cubit.getChildren();
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildActionTile(
                  context,
                  title: 'طلبات الدفع',
                  icon: Icons.payments_rounded,
                  iconColor: Colors.purple,
                  onTap: () => context.pushNamed(AppRoutes.paymentRequests),
                ),
                const SizedBox(height: 12),
                _buildActionTile(
                  context,
                  title: 'تسجيل الخروج',
                  icon: Icons.logout_rounded,
                  iconColor: Colors.red,
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
    return _buildActionTile(
      context,
      title: 'الإشعارات',
      icon: Icons.notifications_active_rounded,
      iconColor: AppColors.primary,
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
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    required IconData icon,
    required Color iconColor,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: CustomContainer(
        borderRadius: 12,
        borderAlpha: 0.3,
        borderWidth: 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isLogout ? Colors.red : AppColors.c303030,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, color: isLogout ? Colors.red : Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}