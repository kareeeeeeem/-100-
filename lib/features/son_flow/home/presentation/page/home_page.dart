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
import 'package:lms/features/son_flow/home/presentation/manager/profile_cubit.dart';
import 'package:lms/features/on_boarding/presentation/manger/my_courses_cubit.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_cubit.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_state.dart';
import 'package:lms/features/son_flow/live_sessions/data/models/live_session_model.dart';


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
    context.read<LiveSessionCubit>().loadLiveSessions();
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

  Future<void> _onRefresh() async {
    // تحديث بيانات الهوم، البروفايل، والكورسات معاً
    await Future.wait<void>([
      GetIt.instance<HomeCubit>().fetchHomeData(),
      context.read<ProfileCubit>().getProfileData(isSilent: true),
      context.read<MyCoursesCubit>().fetchMyCourses(),
    ]);
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

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                      child:// قسم البث المباشر الحقيقي
                     // استبدل الكود اللي إنت بعته بالنسخة دي:
// استبدل جزء الـ BlocBuilder بتاع اللايفات بهذا الكود المباشر:
BlocProvider(
  // بنوفر الكيوبيت هنا مخصوص للهوم عشان ننهي مشكلة الـ Provider NotFound
  create: (context) => GetIt.instance<LiveSessionCubit>()..loadLiveSessions(),
  child: BlocBuilder<LiveSessionCubit, LiveSessionState>(
    builder: (context, state) {
      if (state is LiveSessionsLoaded) {
        // بنعرض المتاح والأرشيف عشان نضمن إن الدائرة تظهر لو فيه أي داتا
        final allLives = [...state.sessions.availableNow, ...state.sessions.archived];

        if (allLives.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allLives.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _buildActualLiveCircle(allLives[index]),
          ),
        );
      } 
      
      if (state is LiveSessionError) {
        // لو السيرفر مطلع 404 أو أي Error هيظهر هنا بدل التحميل اللانهائي
        return Center(child: Text("Error: ${state.message}", style: const TextStyle(fontSize: 10)));
      }

      // حالة التحميل (الـ Loading)
      return const Center(child: CircularProgressIndicator());
    },
  ),
)
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
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildActualLiveCircle(LiveSessionModel session) {
  return GestureDetector(
    onTap: () {
      // بينادي على ميثود الانضمام اللي شغالة في القسم التاني
      context.read<LiveSessionCubit>().joinSession(session.id);
    },
    child: Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF4DC9D1)]),
                shape: BoxShape.circle
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: ClipOval(
                    child: CustomImage(
                      imagePath: session.thumbnail ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 2, right: 2,
              child: Container(
                width: 15, height: 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 75,
          child: Text(
            session.title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

  // ميثود دائرة البث المباشر
  Widget _buildLiveCircle(SliderModel slider) {
  String imagePath = slider.image ?? '';

  // ده التعديل الجوهري لصور البثوث
  if (imagePath.startsWith('http')) {
    // لو الرابط كامل سيبه زي ما هو
  } else if (imagePath.startsWith('assets/')) {
    // لو بدأ بـ assets ما تزودش storage لأنها بتعمل Error 403
    imagePath = imagePath; 
  } else {
    // أي حاجة تانية زود storage عادي
    imagePath = 'storage/$imagePath';
  }

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
                imagePath: imagePath, // هيبعت الرابط من غير storage
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
                      if (course.pricing?.hasDiscount == true) ...[
                        _buildBadge('${course.pricing?.originalPrice} SAR', Colors.grey, isLineThrough: true),
                        const SizedBox(width: 8),
                      ],
                      _buildBadge(course.pricing?.label ?? (course.isFree ? "مجاني" : course.priceLabel), AppColors.c589B6E),
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

  Widget _buildBadge(String text, Color color, {bool isLineThrough = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          decoration: isLineThrough ? TextDecoration.lineThrough : null,
          decorationColor: Colors.white,
        ),
      ),
    );
  }
}