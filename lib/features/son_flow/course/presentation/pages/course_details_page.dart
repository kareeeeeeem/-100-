import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_cubit.dart';
import 'package:lms/features/son_flow/payment/presentation/widgets/payment_bottom_sheet.dart';
import 'package:lms/features/son_flow/community/presentation/manager/favorite_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/payment_cubit.dart';
import 'package:lms/core/widgets/custom_image.dart';

class CourseDetailsPage extends StatefulWidget {
  final int courseId; // استلام الـ ID من الـ Router

  const CourseDetailsPage({super.key, required this.courseId});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  @override
  void initState() {
    super.initState();
    // استدعاء البيانات عند فتح الصفحة
    context.read<CourseDetailsCubit>().fetchCourseDetails(widget.courseId);
  }

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
          title: const Text('تفاصيل الدورة'),
          actionsPadding: const EdgeInsetsDirectional.only(end: 16),
          actions: [
            BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
              builder: (context, detailsState) {
                bool isFavorited = false;
                if (detailsState is CourseDetailsSuccess) {
                  isFavorited = detailsState.model.data?.isFavorited ?? false;
                }
                return BlocConsumer<FavoriteCubit, FavoriteState>(
                  listener: (context, favoriteState) {
                    if (favoriteState is FavoriteError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(favoriteState.message)),
                      );
                    }
                  },
                  builder: (context, favoriteState) {
                    bool currentStatus = isFavorited;
                    if (favoriteState is FavoriteSuccess) {
                      currentStatus = favoriteState.isFavorited;
                    }
                    if (favoriteState is FavoriteLoading) {
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        context.read<FavoriteCubit>().toggleFavorite(widget.courseId);
                      },
                      child: Icon(
                        currentStatus ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.primary,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
          builder: (context, state) {
            if (state is CourseDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CourseDetailsError) {
              return Center(child: Text(state.message));
            } else if (state is CourseDetailsSuccess) {
              final course = state.model.data;
              if (course == null) return const Center(child: Text("لا توجد بيانات"));

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- صورة الدورة (Thumbnail) ---
                      Container(
                        height: MediaQuery.sizeOf(context).height / 3,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.15),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomImage(
                                imagePath: course.thumbnail,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.0),
                                      Colors.black.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- العنوان ---
                      Text(
                        course.title ?? '',
                        style: const TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),

                      // --- مدة الدورة ---
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(course.duration ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- Tags (دروس، سعر، قسم) ---
                      Row(
                        children: [
                          _buildTag('${course.lessons?.length ?? 0} دروس', AppColors.primary),
                          const SizedBox(width: 10),
                          _buildTag(course.price?.label ?? 'مجاني', AppColors.c589B6E),
                          const SizedBox(width: 10),
                          _buildTag(course.category ?? 'عام', AppColors.c589B6E),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- الوصف ---
                      Text(
                        course.description ?? '',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 20),

                      // --- بيانات المدرس ---
                      InkWell(
                        onTap: () => context.pushNamed(AppRoutes.instructorProfile),
                        child: Row(
                          children: [
                            Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                ),
                                child: ClipOval(
                                  child: CustomImage(
                                    imagePath: course.instructor?.image,
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.instructor?.name ?? 'مدرس الدورة',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const Text(
                                  'مدرب معتمد',
                                  style: TextStyle(fontSize: 10, color: AppColors.c9D9FA0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- قائمة الدروس ---
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
                            itemCount: course.lessons?.length ?? 0,
                            separatorBuilder: (context, index) => const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              final lesson = course.lessons![index];
                              return Row(
                                children: [
                                  const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 40),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lesson.title ?? '',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          lesson.duration ?? '',
                                          style: const TextStyle(fontSize: 12, color: AppColors.c8C8C8C),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),);
              }
            return const SizedBox();
          },
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
                builder: (modalContext) {
                  return BlocProvider.value(
                    value: context.read<PaymentCubit>(),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.9,
                      child: PaymentBottomSheet(courseId: widget.courseId),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}