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
        backgroundColor: AppColors.cF6F7FA,
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
                physics: const BouncingScrollPhysics(),
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

                      Row(
                        children: [
                        // استعمل الحقل الذي ظهر في الـ Log
                        _buildTag('${course.totalLessonsCount ?? course.lessonsCount ?? 0} دروس', AppColors.primary),                          const SizedBox(width: 10),
                          if (course.pricing?.hasDiscount == true) ...[
                              _buildTag('${course.pricing?.originalPrice} SAR', Colors.grey, isLineThrough: true),
                              const SizedBox(width: 10),
                            ],
                          _buildTag(
                            (course.pricing?.hasDiscount == true)
                                ? '${course.pricing!.currentPrice} ${course.pricing?.currency ?? 'SAR'}'
                                : (course.price?.value != null && (double.tryParse(course.price!.value ?? '0') ?? 0) > 0)
                                    ? '${course.price!.value} SAR'
                                    : '0.00 SAR',
                            AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          _buildTag(course.pricing?.label ?? course.price?.label ?? 'مجاني', AppColors.c589B6E),
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

              // --- قسم المدرسين ---
if (course.instructors != null && course.instructors!.isNotEmpty) ...[
  const SizedBox(height: 24),
  const Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: Text(
      'مدرسين الدورة',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.c1E1E1E),
    ),
  ),
  const SizedBox(height: 12),
  ...course.instructors!.map((instructor) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          onTap: () {
            if (instructor.id != null) {
              context.pushNamed(
                AppRoutes.instructorProfile,
                extra: instructor.id.toString(),
              );
            }
          },
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
            ),
            child: ClipOval(
              child: CustomImage(
                imagePath: instructor.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                isUserProfile: true,
              ),
            ),
          ),
          title: Text(
            instructor.name ?? 'مدرس غير معروف',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: const Text(
            'عرض السيرة الذاتية والملف الشخصي',
            style: TextStyle(color: AppColors.primary, fontSize: 12),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
        ),
      )).toList(),
],
// --- نهاية بيانات المدرس --
                      const SizedBox(height: 20),
// Container(
//   width: double.infinity,
//   padding: EdgeInsets.all(10),
//   color: Colors.red,
//   child: Text("عدد المدرسين في الداتا: ${course.instructors?.length}"),
// ),
                      // --- قائمة الدروس أو السكاشن ---
                      if (course.isSubscribed && ((course.sections != null && course.sections!.isNotEmpty) || (course.lessons != null && course.lessons!.isNotEmpty)))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'محتوى الدورة',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (course.sections != null && course.sections!.isNotEmpty)
                              ...course.sections!.map((section) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.cE8E8E8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                      child: ListTile(
                                        onTap: () {
                                          context.push(
                                            AppRoutes.courseSectionDetails,
                                            extra: {
                                              'section': section,
                                              'courseId': widget.courseId,
                                              'sections': course.sections,
                                              'currentIndex': course.sections!.indexOf(section),
                                            },
                                          );
                                        },
                                        title: Text(
                                          section.title,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        leading: const Icon(Icons.folder_open_rounded, color: AppColors.primary),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Text(
                                              //   '${section.lessons?.length ?? 0} درس',
                                              //   style: const TextStyle(
                                              //     fontSize: 12,
                                              //     color: AppColors.primary,
                                              //     fontWeight: FontWeight.bold,
                                              //   ),
                                              // ),
                                              SizedBox(width: 4),
                                              Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                );
                              })
                            else
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.cF6F7FA,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(12),
                                  itemCount: course.lessons?.length ?? 0,
                                  separatorBuilder: (context, index) => const Divider(height: 24, color: AppColors.cE8E8E8),
                                  itemBuilder: (context, index) {
                                    final lesson = course.lessons![index];
                                    return _buildLessonItem(lesson, course, context);
                                  },
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 120),
                    ],
                  ),
              
              
              
              
              
              
              
                ),
              );
              
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
                    if (course != null) {
                      _handleAction(course, context);
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

  Widget _buildLessonItem(dynamic lesson, dynamic course, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => _handleAction(course, context),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title ?? '',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.c1E1E1E),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lesson.duration ?? '',
                      style: const TextStyle(fontSize: 11, color: AppColors.c8C8C8C),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.lock_outline_rounded, color: AppColors.cC7C9D9, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAction(dynamic course, BuildContext context) {
    if (course.isSubscribed) {
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
                amount: double.tryParse((course.pricing?.currentPrice?.toString() ?? course.price?.value ?? '0')
                        .replaceAll(RegExp(r'[^0-9.]'), '')) ??
                    0.0,
                courseTitle: course.title ?? '',
                priceLabel: (course.pricing?.label?.isNotEmpty ?? false)
                    ? course.pricing!.label!
                    : (course.price?.label?.isNotEmpty ?? false)
                        ? course.price!.label!
                        : (course.pricing?.currentPrice != null)
                            ? '${course.pricing!.currentPrice} ${course.pricing?.currency ?? 'SAR'}'
                            : (course.price?.value != null)
                                ? '${course.price!.value} SAR'
                                : '0.00 SAR',
                originalPrice: course.pricing?.originalPrice,
                discountPercentage: course.pricing?.discountPercentage,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildTag(String label, Color color, {bool isLineThrough = false}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          decoration: isLineThrough ? TextDecoration.lineThrough : null,
          decorationColor: Colors.white,
        ),
      ),
    );
  }
}