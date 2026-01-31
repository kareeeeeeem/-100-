import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/shared_app_bar.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/course_categories_list_view.dart';
import 'package:lms/features/son_flow/home/presentation/manager/home_cubit.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/presentation/manager/home_cubit.dart'; // تأكد من المسار الصحيح للـ Cubit عندك
import 'package:lms/core/widgets/custom_image.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activeCourseIndex = 0;
  final _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    GetIt.instance<HomeCubit>().fetchHomeData();
    _carouselController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_carouselController.offset >= 0) {
      final itemWidth = MediaQuery.sizeOf(context).width * 0.8;
      const double paddingRight = 16.0 * 2;
      final double totalStepSize = itemWidth + paddingRight;
      final int newIndex = (_carouselController.offset / totalStepSize).round();

      if (newIndex != _activeCourseIndex) {
        setState(() {
          _activeCourseIndex = newIndex;
        });
      }
    }
  }

  @override
  void dispose() {
    _carouselController.removeListener(_onScroll);
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == HomeStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'حدث خطأ ما'));
          } else if (state.status == HomeStatus.success && state.homeData != null) {
            final data = state.homeData!.data;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('البث المباشر', style: TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600, color: AppColors.c303030)),
                  ),
                  const SizedBox(height: 10),
                  // السلايدر بالصور الحقيقية
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.slider.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, index) => _buildLiveCircle(data.slider[index]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الأقسام', style: TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600, color: AppColors.c303030)),
                        InkWell(
                          onTap: () => context.pushNamed(AppRoutes.categories),
                          child: Text('عرض الكل', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: CourseCategoriesListView(
                      courses: data.categories.map((e) => e.name).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('الدورات المميزة', style: TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600, color: AppColors.c303030)),
                  ),
                  const SizedBox(height: 10),
                  // الكاروسيل بالداتا الحقيقية
                  SizedBox(
                    height: 350,
                    child: // داخل الـ CarouselView في HomePage.dart
CarouselView(
  controller: _carouselController,
  padding: const EdgeInsets.symmetric(horizontal: 16),
  itemExtent: MediaQuery.sizeOf(context).width * 0.8,
  shrinkExtent: MediaQuery.sizeOf(context).width * 0.8,
  // التعديل هنا 👇
  onTap: (index) {
    final selectedCourse = data.featuredCourses[index];
    context.pushNamed(
      AppRoutes.courseDetails,
      extra: selectedCourse.id, // إرسال الـ ID الحقيقي
    );
  },
  children: data.featuredCourses.map((course) {
    return _buildCourseCard(course);
  }).toList(),
),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: _activeCourseIndex,
                      count: data.featuredCourses.length,
                      effect: const WormEffect(spacing: 8.0, radius: 4.0, dotWidth: 16, dotHeight: 8, dotColor: AppColors.cEEEEEE, activeDotColor: AppColors.primary),
                    ),
                  ),
                  
                  // قسم الدورات القادمة لهذا الأسبوع (Upcoming)
                  if (data.upcomingCourses.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('الدورات القادمة لهذا الأسبوع', style: TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600, color: AppColors.c303030)),
                    ),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.upcomingCourses.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      // داخل ListView.separated الخاص بـ data.upcomingCourses
itemBuilder: (context, index) {
  final upcomingCourse = data.upcomingCourses[index]; // استخراج الكورس الحالي
  return GestureDetector(
    onTap: () {
      context.pushNamed(
        AppRoutes.courseDetails,
        extra: upcomingCourse.id, // إرسال الـ ID هنا أيضاً
      );
    },
    child: _buildCourseCard(upcomingCourse),
  );
},
                    ),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ميثود البث المباشر (مرة واحدة فقط)
  Widget _buildLiveCircle(SliderModel slider) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(25.15)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25.15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.15),
                child: CustomImage(
                  imagePath: slider.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0, left: -5,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            padding: const EdgeInsets.all(4),
            child: Container(
              width: 25, height: 25,
              decoration: const BoxDecoration(color: AppColors.c4DC9D1, shape: BoxShape.circle),
              child: const Icon(Icons.video_camera_back, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  // كارت الكورس الموحد
  Widget _buildCourseCard(CourseModel course) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.15),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.15),
              child: CustomImage(
                imagePath: course.thumbnail,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.15),
                gradient: LinearGradient(
                  begin: Alignment.topCenter, 
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title, 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "بواسطة: ${course.instructorName}", 
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                    const SizedBox(width: 5),
                    Text(course.duration, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildBadge(
                      course.isFree ? "مجاني" : course.priceLabel, 
                      AppColors.c589B6E,
                    ),
                    const SizedBox(width: 5),
                    _buildBadge("كورس", AppColors.primary),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}