import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_svgs.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/instructor_profile/presentation/manager/instructor_cubit.dart';
import 'package:lms/features/son_flow/instructor_profile/presentation/manager/instructor_state.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';

class InstructorProfilePage extends StatelessWidget {
  final String instructorId;
  
  const InstructorProfilePage({super.key, required this.instructorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<InstructorCubit>().getInstructorProfile(instructorId);
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (state is InstructorProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ProfileImageAndEdit(
                          imageSize: 150,
                          showEditIcon: false,
                          imagePath: profile.avatar,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: AppSvgs.book.svg(fit: BoxFit.scaleDown),
                              value: profile.stats.courses,
                              label: 'الدورات',
                            ),
                          ),
                          Expanded(
                            child: _buildStatCard(
                              icon: const Icon(
                                Icons.people_outline,
                                color: AppColors.primary,
                              ),
                              value: profile.stats.students,
                              label: 'طالب',
                            ),
                          ),
                          Expanded(
                            child: _buildStatCard(
                              icon: AppSvgs.coin.svg(fit: BoxFit.scaleDown),
                              value: profile.stats.experience,
                              label: '',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'نبذة عن المعلم',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profile.bio,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      if (profile.assistants.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'مساعدو التدريس',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          spacing: 20,
                          children: profile.assistants.map((assistant) {
                            return Expanded(
                              child: CustomContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ProfileImageAndEdit(
                                        imageSize: 66,
                                        showEditIcon: false,
                                        imagePath: assistant.image,
                                      ),
                                      Text(
                                        assistant.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        assistant.role ?? 'مساعد تدريس',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.c737373,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 20),
                      const Text(
                        'دورات ذات صلة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final course = profile.relatedCourses[index];
                          return InkWell(
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.courseDetails,
                                extra: course.id,
                              );
                            },
                            child: _buildCourseCard(course),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                        itemCount: profile.relatedCourses.length,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('لا توجد بيانات'));
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required Widget icon,
    required String value,
    required String label,
  }) {
    return CustomContainer(
      height: 110,
      borderAlpha: 0.4,
      borderWidth: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          icon,
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          if (label.isNotEmpty)
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(CourseModel course) {
    return CustomContainer(
      borderRadius: 10,
      borderAlpha: 0.4,
      borderWidth: 0.3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 10,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                image: course.thumbnail != null
                    ? DecorationImage(
                        image: NetworkImage(course.thumbnail!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            Expanded(
              child: Text(
                course.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
