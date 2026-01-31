import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/custom_outlined_button.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_state.dart';
import 'package:lms/features/son_flow/exams/presentation/widgets/comprehensive_test_answer.dart';

class ComprehensiveExamPage extends StatefulWidget {
  const ComprehensiveExamPage({super.key});

  @override
  State<ComprehensiveExamPage> createState() => _ComprehensiveExamPageState();
}

class _ComprehensiveExamPageState extends State<ComprehensiveExamPage> {
  int _currentQuestionIndex = 0;
  final Map<String, String> _selectedAnswers = {};

  void _nextQuestion(int totalQuestions) {
    if (_currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _prevQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamCubit, ExamState>(
      listener: (context, state) {
        if (state is ExamSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم ارسال الامتحان بنجاح')),
          );
          Navigator.of(context).pop();
        } else if (state is ExamError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ExamLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is ExamLoaded) {
          final exam = state.exam;
          final questions = exam.questions;
          if (questions.isEmpty) {
            return const Scaffold(body: Center(child: Text('لا يوجد اسئلة')));
          }

          final currentQuestion = questions[_currentQuestionIndex];

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height / 4,
                                child: Stack(
                                  children: [
                                    CustomContainer(
                                      height: MediaQuery.sizeOf(context).height / 4,
                                      borderRadius: 8,
                                      color: AppColors.cF7F9FF,
                                      boxShadow: BoxShadow(
                                        offset: const Offset(0, 0),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        color: Colors.black.withValues(alpha: 0.25),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Text(
                                            currentQuestion.questionText,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.c252836,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter.add(
                                        const Alignment(0, -0.2),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.c243C70,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${questions.length}/${_currentQuestionIndex + 1}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              ...currentQuestion.optionsList.map((option) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedAnswers[currentQuestion.id] = option;
                                      });
                                    },
                                    child: ComprehensiveTestAnswer(
                                      answer: option,
                                      isSelected: _selectedAnswers[currentQuestion.id] == option,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentQuestionIndex < questions.length - 1)
                          CustomElevatedButton(
                            title: 'التالي',
                            height: 40,
                            isExpanded: false,
                            onPressed: () => _nextQuestion(questions.length),
                          )
                        else
                          CustomElevatedButton(
                            title: 'انهاء',
                            height: 40,
                            isExpanded: false,
                            onPressed: state is ExamSubmitting 
                              ? null 
                              : () {
                                  context.read<ExamCubit>().submitExam(
                                    exam.id.toString(),
                                    _selectedAnswers,
                                  );
                                },
                          ),
                        CustomOutlinedButton(
                          title: 'السابق',
                          height: 40,
                          isExpanded: false,
                          onPressed: _currentQuestionIndex > 0
                              ? _prevQuestion
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: Text('حدث خطأ ما')));
      },
    );
  }
}
