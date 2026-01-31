import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/core/widgets/shared_app_bar.dart';
import 'package:lms/features/on_boarding/presentation/manger/my_courses_cubit.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/course_categories_list_view.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/running_course_item_view.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final _categories = ['الجميع', 'تصميم واجهات', 'برمجه الموبيل', 'برمجة الويب']; //

  @override
  void initState() {
    super.initState();
    // طلب البيانات من الـ API بمجرد فتح الصفحة
    context.read<MyCoursesCubit>().fetchMyCourses(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(), //
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'الدورات الدراسية الخاصة بي',
                    style: TextStyle(
                      fontSize: 18.86,
                      fontWeight: FontWeight.w700,
                      color: AppColors.c303030,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: CourseCategoriesListView(courses: _categories), //
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          
          // ربط الواجهة بحالات الـ Cubit
          BlocBuilder<MyCoursesCubit, MyCoursesState>(
            builder: (context, state) {
              // 1. حالة التحميل
              if (state.status == MyCoursesStatus.loading) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // 2. حالة النجاح وعرض البيانات الحقيقية
              if (state.status == MyCoursesStatus.success) {
                if (state.courses.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text("لا توجد دورات ملتحق بها حالياً")),
                  );
                }

                return SliverList.separated(
                  itemCount: state.courses.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
           itemBuilder: (context, index) {
  final course = state.courses[index]; 
  
  // تحويل آمن مهما كان نوع البيانات اللي جاي من الباك-إند
  String pPercentage = course.progressPercentage?.toString() ?? '0';
  String lCount = course.lessonsCount?.toString() ?? '0';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: CustomContainer(
      borderRadius: 10,
      borderWidth: 0.3,
      borderAlpha: 0.4,
      child: RunningCourseItemView(
        courseName: course.title,
        // استخدام القيم المحولة نصوص بأمان
        lessonsAndHours: '$lCount دروس . ${course.duration}',
        // التحويل لـ double للـ Progress Bar
        progress: (double.tryParse(pPercentage) ?? 0.0) / 100,
        imageUrl: course.thumbnail,
      ),
    ),
  );
},
                );
              }

              // 3. حالة الخطأ
              if (state.status == MyCoursesStatus.error) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(state.errorMessage ?? "حدث خطأ ما"),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}