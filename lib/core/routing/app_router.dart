import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
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
              return const CourseDetailsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.availableLives,
            name: AppRoutes.availableLives,
            builder: (context, state) {
              return const AvailableLivesPage();
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
              return const InstructorProfilePage();
            },
          ),
         GoRoute(
  path: AppRoutes.subscribedCourseDetails,
  name: AppRoutes.subscribedCourseDetails,
  builder: (context, state) {
    // 1. استلام الـ ID
    final int courseId = state.extra as int? ?? 0; 

    return BlocProvider(
      // 2. بنادي على الـ fetch فوراً مع الـ create باستخدام Cascade Operator (..)
      create: (context) => GetIt.instance<CourseDetailsCubit>()..fetchCourseDetails(courseId),
      child: SubscribedCourseDetailsPage(courseId: courseId),
    );
  },
),
          GoRoute(
            path: AppRoutes.exams,
            name: AppRoutes.exams,
            builder: (context, state) {
              return const ExamsPage();
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
              return const PrefaceExamPage();
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
              return const ComprehensiveExamPage();
            },
          ),
        ],
      ),

      // PARENT FLOW
      GoRoute(
        path: AppRoutes.parentHome,
        name: AppRoutes.parentHome,
        builder: (context, state) {
          return const HomePage();
        },
        routes: [
          GoRoute(
            path: AppRoutes.sonProfileDetailsParent,
            name: AppRoutes.sonProfileDetailsParent,
            builder: (context, state) {
              return const SonProfileDetailsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.editProfileDetailsParent,
            name: AppRoutes.editProfileDetailsParent,
            builder: (context, state) {
              return const EditSonProfileDetailsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.sonExamResults,
            name: AppRoutes.sonExamResults,
            builder: (context, state) {
              return const SonExamResultsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.addNewSon,
            name: AppRoutes.addNewSon,
            builder: (context, state) {
              return const AddNewSonPage();
            },
          ),
          GoRoute(
            path: AppRoutes.paymentRequests,
            name: AppRoutes.paymentRequests,
            builder: (context, state) {
              return const PaymentRequestsPage();
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // const bool loggedIn = true;
      // const String role = 'parent';
      //
      // if (!loggedIn && state.matchedLocation != AppRoutes.login) {
      //   return AppRoutes.login;
      // }
      //
      // if (role == 'son' && state.matchedLocation.startsWith('/parent')) {
      //   return AppRoutes.sonHome;
      // }
      //
      // if (role == 'parent' && state.matchedLocation.startsWith('/son')) {
      //   return AppRoutes.parentHome;
      // }
      return null;
    },
  );
}
