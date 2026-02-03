import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_state.dart';

class PrefaceExamDetailsPage extends StatelessWidget {
  final String examId;
  const PrefaceExamDetailsPage({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ExamCubit, ExamState>(
          builder: (context, state) {
            if (state is ExamLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ExamError) {
              return Center(child: Text(state.message));
            }

            if (state is ExamLoaded) {
              final exam = state.exam;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        height: MediaQuery.sizeOf(context).width * 0.6,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: AppColors.primary),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              exam.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomElevatedButton(
                        title: 'ابدأ',
                        onPressed: () {
                          context.pushNamed(
                            AppRoutes.prefaceExam,
                            extra: examId,
                          );
                        },
                        isExpanded: false,
                        width: MediaQuery.sizeOf(context).width * 0.6,
                      ),
                      const SizedBox(height: 30),
                      Text.rich(
                        TextSpan(
                          text: 'مدة الاختبار: ',
                          children: [
                            TextSpan(
                              text: exam.duration,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'عدد الأسئلة: ${exam.questions.length} سؤال',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'نوع الأسئلة: اختيار متعدد',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
