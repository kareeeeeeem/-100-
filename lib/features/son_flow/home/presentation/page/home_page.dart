import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/shared_app_bar.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/course_categories_list_view.dart';
import 'package:lms/features/son_flow/home/presentation/manager/home_cubit.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
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
    // جلب البيانات عند فتح الصفحة
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'حدث خطأ ما'),
                  ElevatedButton(
                    onPressed: () => GetIt.instance<HomeCubit>().fetchHomeData(),
                    child: const Text("إعادة المحاولة"),
                  )
                ],
              ),
            );
          } else if (state.status == HomeStatus.success && state.homeData != null) {
            final data = state.homeData!.data;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('البث المباشر', 
                      style: TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600, color: AppColors.c303030)),
                  ),
                  const SizedBox(height: 10),
                  
                  // قسم السلايدر (البث المباشر)
                  SizedBox(
                    height: 85,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.slider.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => _buildLiveCircle(data.slider[index]),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // قسم الأقسام
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الأقسام', 
                          style: TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600, color: AppColors.c303030)),
                        InkWell(
                          onTap: () => context.pushNamed(AppRoutes.categories),
                          child: const Text('عرض الكل', 
                            style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: CourseCategoriesListView(
                      categories: data.categories
                          .map((e) => CategoryUIModel(
                                name: e.name,
                                icon: e.icon,
                                id: e.id,
                              ))
                          .toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // قسم الدورات المميزة (Carousel)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('الدورات المميزة', 
                      style: TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600, color: AppColors.c303030)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 220, // تعديل الارتفاع ليناسب التصميم
                    child: CarouselView(
                      controller: _carouselController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemExtent: MediaQuery.sizeOf(context).width * 0.8,
                      shrinkExtent: MediaQuery.sizeOf(context).width * 0.7,
                      onTap: (index) {
                        final course = data.featuredCourses[index];
                        print("🎯 [HomePage] Navigating to Featured Course Details: ID=${course.id}, Title=${course.title}");
                        context.pushNamed(
                          AppRoutes.courseDetails,
                          extra: course.id,
                        );
                      },
                      children: data.featuredCourses.map((course) {
                        return _buildCourseCard(course);
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: _activeCourseIndex,
                      count: data.featuredCourses.length,
                      effect: const WormEffect(
                        spacing: 8.0, radius: 4.0, dotWidth: 16, dotHeight: 8, 
                        dotColor: AppColors.cEEEEEE, activeDotColor: AppColors.primary
                      ),
                    ),
                  ),
                  
                  // قسم الدورات القادمة (Upcoming)
                  if (data.upcomingCourses.isNotEmpty) ...[
                    const SizedBox(height: 25),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('الدورات القادمة لهذا الأسبوع', 
                        style: TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600, color: AppColors.c303030)),
                    ),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.upcomingCourses.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final upcomingCourse = data.upcomingCourses[index];
                        return GestureDetector(
                          onTap: () {
                            print("🎯 [HomePage] Navigating to Upcoming Course Details: ID=${upcomingCourse.id}, Title=${upcomingCourse.title}");
                            context.pushNamed(
                              AppRoutes.courseDetails,
                              extra: upcomingCourse.id,
                            );
                          },
                          child: SizedBox(
                            height: 200, 
                            child: _buildCourseCard(upcomingCourse)
                          ),
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

  // ميثود دائرة البث المباشر
  Widget _buildLiveCircle(SliderModel slider) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 75, height: 75,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF4DC9D1)]),
            borderRadius: BorderRadius.circular(25)
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: CustomImage(
                  imagePath: slider.image, // سيتم معالجته داخل CustomImage الجديد
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -2, right: -2,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            padding: const EdgeInsets.all(3),
            child: Container(
              width: 22, height: 22,
              decoration: const BoxDecoration(color: Color(0xFF4DC9D1), shape: BoxShape.circle),
              child: const Icon(Icons.videocam, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  // كارت الكورس الموحد
  Widget _buildCourseCard(CourseModel course) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CustomImage(
                imagePath: course.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topCenter, 
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title, 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  "د. ${course.instructorName}", 
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView( // To avoid overflow on small screens
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildBadge(course.isFree ? "مجاني" : course.priceLabel, AppColors.c589B6E),
                      const SizedBox(width: 8),
                      // Duration badge with icon
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.white70, size: 10),
                            const SizedBox(width: 4),
                            Text(course.duration, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                          ],
                        ),
                      ),
                      
                      // Category badge if available
                      if (course.category != null && course.category!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                         Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            course.category!, 
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)
                          ),
                        ),
                      ],
                    ],
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}