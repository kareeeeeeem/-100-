import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_state.dart';

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ExamCubit, ExamState>(
          builder: (context, state) {
            if (state is ExamLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ExamsLoaded) {
              final exams = state.exams;
              if (exams.isEmpty) {
                return const Center(child: Text('لا يوجد امتحانات متاحة حالياً'));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'الامتحانات',
                        style: TextStyle(
                          fontSize: 25.15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.c111111,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ...exams.map((exam) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: InkWell(
                            onTap: () {
                              // Decide which detail page to go to based on some criteria 
                              // For now, using preface as default or checking some property
                              context.pushNamed(
                                AppRoutes.prefaceExamDetails,
                                extra: exam.id.toString(),
                              );
                            },
                            child: CustomContainer(
                              borderRadius: 8,
                              borderWidth: 0.5,
                              borderAlpha: 0.7,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  exam.title,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }

            if (state is ExamError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text('ابدأ بالبحث عن الامتحانات'));
          },
        ),
      ),
    );
  }
}
