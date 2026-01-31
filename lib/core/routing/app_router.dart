import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/features/on_boarding/presentation/manger/my_courses_cubit.dart';
import 'package:lms/features/on_boarding/presentation/manger/on_boarding_cubit.dart';
import 'package:lms/features/on_boarding/presentation/pages/on_boarding_page.dart';
import 'package:lms/features/parent_flow/add_new_son/presentation/pages/add_new_son_page.dart';
import 'package:lms/features/parent_flow/exams_results/presentation/pages/son_exam_results_page.dart';
import 'package:lms/features/parent_flow/home/presentation/pages/home_page.dart';
import 'package:lms/features/parent_flow/payment/presentation/pages/payment_requests_page.dart';
import 'package:lms/features/parent_flow/son_profile/presentation/pages/edit_son_profile_details_page.dart';
import 'package:lms/features/parent_flow/son_profile/presentation/pages/son_profile_details_page.dart';
import 'package:lms/features/son_flow/course/presentation/pages/course_details_page.dart';
import 'package:lms/features/son_flow/course/presentation/pages/subscribed_course_details_page.dart';
import 'package:lms/features/son_flow/exams/presentation/pages/comprehensive_exam_details_page.dart';
import 'package:lms/features/son_flow/exams/presentation/pages/comprehensive_exam_page.dart';
import 'package:lms/features/son_flow/exams/presentation/pages/exams_page.dart';
import 'package:lms/features/son_flow/exams/presentation/pages/preface_exam_details_page.dart';
import 'package:lms/features/son_flow/exams/presentation/pages/preface_exam_page.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_cubit.dart';
import 'package:lms/features/son_flow/home/di/home_di.dart';
import 'package:lms/features/son_flow/home/presentation/manager/categories_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/home_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/search_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/page/categories_page.dart';
import 'package:lms/features/son_flow/home/presentation/page/search_page.dart';
import 'package:lms/features/son_flow/home/presentation/page/home_layout.dart';
import 'package:lms/features/son_flow/instructor_profile/presentation/pages/instructor_profile_page.dart';
import 'package:lms/features/son_flow/lives/presentation/pages/available_lives_page.dart';
import 'package:lms/features/son_flow/login/presentation/login_page.dart';
import 'package:lms/features/son_flow/login/presentation/manager/login_cubit.dart';
import 'package:lms/features/son_flow/profile/presentation/pages/edit_profile_details_page.dart';
import 'package:lms/features/son_flow/profile/presentation/pages/profile_details_page.dart';
import 'package:lms/features/son_flow/register/presentation/manager/register_cubit.dart';
import 'package:lms/features/son_flow/register/presentation/register_page.dart';
import 'package:lms/features/splash/presentation/manager/splash_cubit.dart';
import 'package:lms/features/splash/presentation/pages/splash_page.dart';
import 'package:lms/features/son_flow/instructor_profile/presentation/manager/instructor_cubit.dart';
import 'package:lms/features/son_flow/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:lms/features/son_flow/dashboard/presentation/pages/dashboard_page.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_cubit.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_cubit.dart';
import 'package:lms/features/son_flow/community/presentation/manager/favorite_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/payment_cubit.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_cubit.dart';

final class AppRouter {
  AppRouter._();

  static AppRouter? _instance;

  factory AppRouter() {
    return _instance ??= AppRouter._();
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  final router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      // SHARED FLOW
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => GetIt.instance<SplashCubit>(),
            lazy: false,
            child: const SplashPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onBoarding,
        name: AppRoutes.onBoarding,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => GetIt.instance<OnBoardingCubit>(),
            child: const OnBoardingPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => GetIt.instance<LoginCubit>(),
            child: const LoginPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.register,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => GetIt.instance<RegisterCubit>(),
            child: const RegisterPage(),
          );
        },
      ),

      // SON FLOW
      GoRoute(
        path: AppRoutes.sonHome,
        name: AppRoutes.sonHome,
        builder: (context, state) {
          HomeDi().init();
          return const HomeLayout();
        },
        routes: [
         GoRoute(
  path: AppRoutes.courseDetails,
  name: AppRoutes.courseDetails,
  builder: (context, state) {
    // التعديل الآمن هنا 👇
    final Object? extra = state.extra;
    int courseId = 0;

    if (extra is int) {
      courseId = extra;
    } else if (extra is String) {
      courseId = int.tryParse(extra) ?? 0;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance<CourseDetailsCubit>()..fetchCourseDetails(courseId),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<CommentsCubit>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<FavoriteCubit>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<PaymentCubit>(),
        ),
      ],
      child: CourseDetailsPage(courseId: courseId),
    );
  },
),
          GoRoute(
            path: AppRoutes.availableLives,
            name: AppRoutes.availableLives,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => GetIt.instance<LiveSessionCubit>()..loadLiveSessions(),
                child: const AvailableLivesPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.categories,
            name: AppRoutes.categories,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => GetIt.instance<CategoriesCubit>(),
                child: const CategoriesPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.search,
            name: AppRoutes.search,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => GetIt.instance<SearchCubit>(),
                child: const SearchPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.sonProfileDetails,
            name: AppRoutes.sonProfileDetails,
            builder: (context, state) {
              return const ProfileDetailsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.editProfileDetails,
            name: AppRoutes.editProfileDetails,
            builder: (context, state) {
              return const EditProfileDetailsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.instructorProfile,
            name: AppRoutes.instructorProfile,
            builder: (context, state) {
              final String instructorId = state.extra as String? ?? '1';
              return BlocProvider(
                create: (context) => GetIt.instance<InstructorCubit>()
                  ..getInstructorProfile(instructorId),
                child: InstructorProfilePage(instructorId: instructorId),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            name: AppRoutes.dashboard,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => GetIt.instance<DashboardCubit>()
                  ..loadDashboardStats(),
                child: const DashboardPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.subscribedCourseDetails,
            name: AppRoutes.subscribedCourseDetails,
            builder: (context, state) {
              final int courseId = state.extra as int? ?? 0;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => GetIt.instance<CourseDetailsCubit>()
                      ..fetchCourseDetails(courseId),
                  ),
                  BlocProvider(
                    create: (context) => GetIt.instance<CommentsCubit>(),
                  ),
                  BlocProvider(
                    create: (context) => GetIt.instance<FavoriteCubit>(),
                  ),
                ],
                child: SubscribedCourseDetailsPage(courseId: courseId),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.exams,
            name: AppRoutes.exams,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => GetIt.instance<ExamCubit>()..loadExams(),
                child: const ExamsPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.prefaceExamDetails,
            name: AppRoutes.prefaceExamDetails,
            builder: (context, state) {
              return const PrefaceExamDetailsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.prefaceExam,
            name: AppRoutes.prefaceExam,
            builder: (context, state) {
              final String examId = state.extra as String? ?? '1';
              return BlocProvider(
                create: (context) => GetIt.instance<ExamCubit>()..loadExam(examId),
                child: const PrefaceExamPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.comprehensiveExamDetails,
            name: AppRoutes.comprehensiveExamDetails,
            builder: (context, state) {
              return const ComprehensiveExamDetailsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.comprehensiveExam,
            name: AppRoutes.comprehensiveExam,
            builder: (context, state) {
              final String examId = state.extra as String? ?? '1';
              return BlocProvider(
                create: (context) => GetIt.instance<ExamCubit>()..loadExam(examId),
                child: const ComprehensiveExamPage(),
              );
            },
          ),
        ],
      ),

      // PARENT FLOW
      GoRoute(
        path: AppRoutes.parentHome,
        name: AppRoutes.parentHome,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => GetIt.instance<ParentCubit>()
              ..getChildren()
              ..getParentCourses(),
            child: const HomePage(),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.sonProfileDetailsParent,
            name: AppRoutes.sonProfileDetailsParent,
            builder: (context, state) {
              final childId = state.extra as int? ?? 0;
              return BlocProvider(
                create: (context) => GetIt.instance<ParentCubit>()..getChildDetails(childId),
                child: SonProfileDetailsPage(childId: childId),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.editProfileDetailsParent,
            name: AppRoutes.editProfileDetailsParent,
            builder: (context, state) {
              final childId = state.extra as int? ?? 0;
              return BlocProvider(
                create: (context) => GetIt.instance<ParentCubit>()..getChildDetails(childId),
                child: const EditSonProfileDetailsPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.sonExamResults,
            name: AppRoutes.sonExamResults,
            builder: (context, state) {
              final childId = state.extra as int? ?? 0;
              return BlocProvider(
                create: (context) => GetIt.instance<ParentCubit>()..getChildExamResults(childId),
                child: const SonExamResultsPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.addNewSon,
            name: AppRoutes.addNewSon,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => GetIt.instance<ParentCubit>(),
                child: const AddNewSonPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.paymentRequests,
            name: AppRoutes.paymentRequests,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => GetIt.instance<ParentCubit>(),
                child: const PaymentRequestsPage(),
              );
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      return null;
    },
  );
}