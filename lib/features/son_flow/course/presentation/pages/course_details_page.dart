import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/son_flow/course/presentation/pages/WishlistCubit.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_cubit.dart';
import 'package:lms/features/son_flow/payment/presentation/widgets/payment_bottom_sheet.dart';
import 'package:lms/features/son_flow/home/presentation/manager/payment_cubit.dart';
import 'package:lms/core/widgets/custom_image.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_cubit.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/course_comments_bottom_sheet.dart';

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
                        child: // داخل Column في الـ SingleChildScrollView
Stack(
  children: [
    // 1. الصورة (أول طبقة تحت)
    Positioned.fill(
      child: CustomImage(
        imagePath: course.thumbnail,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    ),
    
    // 2. التدرج الأسود (لازم يكون فوق الصورة وتحت الزرار)
    Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.8)],
          ),
        ),
      ),
    ),

    // 3. زر القلب (آخر طبقة فوق عشان يلمس)
    Positioned(
      top: 15,
      left: 15,
      child: BlocConsumer<WishlistCubit, WishlistState>(
        listener: (context, state) {
          if (state is WishlistToggleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.primary),
            );
          } else if (state is WishlistError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<WishlistCubit>();
          final bool isFav = cubit.isCourseFavorited(widget.courseId, course.isFavorited);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print("🖱️ [UI] Toggle Favorite Clicked for ID: ${widget.courseId}");
                cubit.toggleFavorite(widget.courseId);
              },
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: (state is WishlistLoading)
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      )
                    : Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
              ),
            ),
          );
        },
      ),
    ),
  ],
),
                      ),
                      const SizedBox(height: 10),

                      // --- العنوان والتعليقات ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              course.title ?? '',
                              style: const TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                builder: (sheetContext) => BlocProvider.value(
                                  value: context.read<CommentsCubit>()..loadComments(widget.courseId),
                                  child: CourseCommentsBottomSheet(
                                    courseId: widget.courseId,
                                    isSubscribed: course.isSubscribed,
                                  ),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Text('التعليقات', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                                SizedBox(width: 4),
                                Icon(Icons.comment_outlined, color: AppColors.primary, size: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- Tags (دروس، سعر، قسم) ---
                      Row(
                        children: [
                          _buildTag('${course.lessonsCount ?? course.lessons?.length ?? 0} دروس', AppColors.primary),
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
  onTap: () {
    if (course.instructor?.id != null) {
      // بنستخدم navigatorKey عشان نتخطى أي مشاكل في الـ context
      AppRouter.navigatorKey.currentContext?.pushNamed(
        AppRoutes.instructorProfile,
        extra: course.instructor!.id.toString(),
      );
    } else {
      print("Instructor ID is null!"); // عشان تتأكد في الـ Terminal لو الداتا ناقصة
    }
  },
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
                                    isUserProfile: true, // Use avatar placeholder
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
                                if (course.instructor?.stats != null)
                                  Text(
                                    '${course.instructor?.stats?.students ?? 0} طالب | ${course.instructor?.stats?.courses ?? 0} دورة',
                                    style: const TextStyle(fontSize: 10, color: AppColors.c9D9FA0),
                                  )
                                // else
                                //   const Text(
                                //     'مدرب معتمد',
                                //     style: TextStyle(fontSize: 10, color: AppColors.c9D9FA0),
                                //   ),
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
        bottomSheet: BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
          builder: (context, state) {
            if (state is CourseDetailsSuccess) {
              final course = state.model.data;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: CustomElevatedButton(
                  title: (course?.isSubscribed ?? false) ? 'الذهاب الى الكورس' : 'احجز الان',
                  onPressed: () {
                    if (course?.isSubscribed ?? false) {
                      context.pushNamed(AppRoutes.subscribedCourseDetails, extra: widget.courseId);
                    } else {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (modalContext) {
                          return BlocProvider.value(
                            value: context.read<PaymentCubit>(),
                            child: SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.9,
                              child: PaymentBottomSheet(
                                courseId: widget.courseId,
                                amount: double.tryParse((course?.price?.value ?? '0')
                                        .replaceAll(RegExp(r'[^0-9.]'), '')) ??
                                    0.0,
                                courseTitle: course?.title ?? '',
                                priceLabel: course?.price?.label ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
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