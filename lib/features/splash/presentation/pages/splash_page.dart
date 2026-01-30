import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/features/splash/presentation/manager/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
@override
  void initState() {
    // نادينا على الدالة الموحدة
    context.read<SplashCubit>().checkStatus();
    
    Future.delayed(const Duration(seconds: 2), _navigateToNextPage);
    super.initState();
  }

  void _navigateToNextPage() {
    if (mounted) {
      final state = context.read<SplashCubit>().state;
      if (state.isUserLoggedIn) {
        // التوجيه الذكي
        if (state.userType == 'student') {
          context.go(AppRoutes.sonHome);
        } else {
          context.go(AppRoutes.parentHome);
        }
      } else {
        if (!state.isOnBoardingCompleted) {
          context.go(AppRoutes.onBoarding);
        } else {
          context.go(AppRoutes.login);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppImages.logo
            .image(
              fit: BoxFit.contain,
              width: MediaQuery.sizeOf(context).width * 0.7,
              height: MediaQuery.sizeOf(context).height / 4,
            )
            .animate()
            .fade(duration: 1.seconds)
            .scale(delay: 300.ms),
      ),
    );
  }
}
