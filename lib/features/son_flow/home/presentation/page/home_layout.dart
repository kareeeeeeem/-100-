import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// المسارات الخاصة بالمشروع
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_svgs.dart';
import 'package:lms/features/on_boarding/presentation/manger/my_courses_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/page/home_page.dart';
import 'package:lms/features/son_flow/course/presentation/pages/my_courses_page.dart';
import 'package:lms/features/son_flow/profile/presentation/pages/profile_page.dart';
import 'package:lms/features/son_flow/home/presentation/manager/home_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/widgets/bottom_nav_bar_indicator.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _activeIndex = 0;

  // قمنا بتعريف الليستة هنا لتمكين الـ BlocProvider لكل صفحة بشكل مستقل
  late final List<Widget> _pages;

  @override
void initState() {
  super.initState();
  _pages = [
    const HomePage(),
    // كورساتي
    BlocProvider(
      create: (context) => GetIt.instance<MyCoursesCubit>(),
      child: const MyCoursesPage(),
    ),
    // البروفايل (التعديل هنا)
    BlocProvider(
      create: (context) => GetIt.instance<ProfileCubit>(),
      child: const ProfilePage(),
    ),
  ];
}

  void _updateActiveIndex(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // الـ HomeLayout نفسه متغلف بالـ HomeCubit الأساسي
    return BlocProvider(
      create: (context) => GetIt.instance<HomeCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: IndexedStack( // استخدام IndexedStack أفضل للحفاظ على حالة الصفحات
              index: _activeIndex,
              children: _pages,
            ),
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                currentIndex: _activeIndex,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.cC7C9D9,
                enableFeedback: false,
                onTap: _updateActiveIndex,
                items: [
                  // أيقونة الهوم
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: AppSvgs.menuUnselected.svg(
                      width: 18, height: 18, fit: BoxFit.scaleDown,
                    ),
                    activeIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSvgs.menuSelected.svg(
                          width: 18, height: 18, fit: BoxFit.scaleDown,
                        ),
                        const BottomNavBarIndicator(),
                      ],
                    ),
                  ),
                  // أيقونة كورساتي
                  BottomNavigationBarItem(
                    label: 'Courses',
                    icon: AppSvgs.courses.svg(width: 22, height: 22, fit: BoxFit.scaleDown),
                    activeIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSvgs.courses.svg(
                          width: 22, height: 22, fit: BoxFit.scaleDown,
                          color: AppColors.primary,
                        ),
                        const BottomNavBarIndicator(),
                      ],
                    ),
                  ),
                  // أيقونة البروفايل
                  const BottomNavigationBarItem(
                    label: 'Profile',
                    icon: Icon(Icons.person_outline, color: AppColors.cC7C9D9),
                    activeIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline, color: AppColors.primary),
                        BottomNavBarIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}