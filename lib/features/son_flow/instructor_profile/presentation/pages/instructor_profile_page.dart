import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_svgs.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';
import 'package:lms/features/son_flow/instructor_profile/data/models/instructor_profile_model.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart'; // للوصول لـ CourseModel
import 'package:lms/features/son_flow/instructor_profile/presentation/manager/instructor_cubit.dart';
import 'package:lms/features/son_flow/instructor_profile/presentation/manager/instructor_state.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/widgets/custom_image.dart';

class InstructorProfilePage extends StatelessWidget {
  final String instructorId;

  const InstructorProfilePage({super.key, required this.instructorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<InstructorCubit>()..getInstructorProfile(instructorId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<InstructorCubit, InstructorState>(
            builder: (context, state) {
              if (state is InstructorLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is InstructorError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      Text(state.message),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => context
                            .read<InstructorCubit>()
                            .getInstructorProfile(instructorId),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              } else if (state is InstructorProfileLoaded) {
                final profile = state.profile;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // صورة البروفايل
                      Center(
                        child: ProfileImageAndEdit(
                          imageSize: 120,
                          showEditIcon: false,
                          imagePath: profile.avatar,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // اسم المعلم
                      Center(
                        child: Text(
                          profile.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // الإحصائيات (Stats)
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: AppSvgs.book.svg(color: AppColors.primary),
                              value: profile.stats.courses,
                              label: 'دورة',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatCard(
                              icon: const Icon(Icons.people_outline,
                                  color: AppColors.primary),
                              value: profile.stats.students,
                              label: 'طالب',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatCard(
                              icon: const Icon(Icons.workspace_premium_outlined,
                                  color: AppColors.primary),
                              value: profile.stats.experience,
                              label: 'خبرة',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // السيرة الذاتية (Bio)
                      const Text('نبذة عن المعلم',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
Center( // تغليف النص بـ Center لضمان التوسط الأفقي
  child: Text(
    profile.bio.isEmpty ? 'لا توجد سيرة ذاتية.' : profile.bio,
    textAlign: TextAlign.center, // لسنترة الأسطر إذا كانت النبذة طويلة
    style: const TextStyle(
      fontSize: 14,
      color: Colors.black87,
    ),
  ),
),                      
                      // قسم المساعدين (البيانات الجديدة)
                      if (profile.assistants.isNotEmpty) ...[
                        const SizedBox(height: 25),
                        const Text('مساعدو التدريس',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: profile.assistants.length,
                            itemBuilder: (context, index) {
                              final assistant = profile.assistants[index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Column(
                                  children: [
                                    CustomImage(
                                      imagePath: assistant.image,
                                      width: 65,
                                      height: 65,
                                      borderRadius: 35,
                                      isUserProfile: true,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      assistant.name,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      assistant.role ?? '', // إضافة الـ ?? لضمان عدم وجود قيمة null
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 25),
                      // دورات المعلم (Related Courses)
                      const Text('دورات المدرب',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: profile.relatedCourses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            _buildCourseCard(context, profile.relatedCourses[index]),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

Widget _buildStatCard(
      {required Widget icon, required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // توسيط عمودي
        crossAxisAlignment: CrossAxisAlignment.center, // توسيط أفقي
        children: [
          icon,
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center, // لضمان سنترة النص إذا زاد طوله
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            textAlign: TextAlign.center, // لضمان سنترة التسمية
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseModel course) {
    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.courseDetails, extra: course.id),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: Row(
          children: [
            CustomImage(
                imagePath: course.thumbnail,
                width: 75,
                height: 75,
                borderRadius: 8),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(course.category ?? '',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.primary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}