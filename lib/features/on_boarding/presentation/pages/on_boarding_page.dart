import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/on_boarding/presentation/manger/on_boarding_cubit.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImages.splashLogo.image(height: 303, fit: BoxFit.contain),
              const SizedBox(height: 20),
              const Text.rich(
                TextSpan(
                  text: 'مرحبا بك في منصة ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.c303030,
                  ),
                  children: [
                    TextSpan(
                      text: '100 للقدرات',
                      style: TextStyle(color: AppColors.c589B6E),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'أفضل وأشهر تطبيقات الكورسات التعليمية المباشرة من المنزل',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.c8C8C8C,
                ),
              ),
              const SizedBox(height: 20),
              Builder(
                builder: (c) {
                  return CustomElevatedButton(
                    title: 'ابدأ الان',
                    onPressed: () {
                      c.read<OnBoardingCubit>().completeOnBoarding();
                      context.pushNamed(AppRoutes.login);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


