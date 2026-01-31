import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/custom_outlined_button.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_state.dart';

class PrefaceExamPage extends StatefulWidget {
  const PrefaceExamPage({super.key});

  @override
  State<PrefaceExamPage> createState() => _PrefaceExamPageState();
}

class _PrefaceExamPageState extends State<PrefaceExamPage> {
  int _currentQuestionIndex = 0;
  final Map<String, String> _selectedAnswers = {};

  void _updateCurrentQuestionIndex(int index) {
    setState(() {
      _currentQuestionIndex = index;
    });
  }

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
          // Navigate to results or show success
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children: List.generate(questions.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    _updateCurrentQuestionIndex(index);
                                  },
                                  child: Container(
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 4),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          color: Colors.black.withValues(alpha: 0.25),
                                        ),
                                      ],
                                      color: _currentQuestionIndex == index
                                          ? AppColors.c243C70
                                          : Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: _currentQuestionIndex == index
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'سؤال ${_currentQuestionIndex + 1} : ',
                                  children: [
                                    TextSpan(
                                      text: currentQuestion.questionText,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              Column(
                                children: currentQuestion.optionsList.map((option) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedAnswers[currentQuestion.id] = option;
                                        });
                                      },
                                      child: Row(
                                        spacing: 10,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Radio<String>.adaptive(
                                            value: option,
                                            groupValue: _selectedAnswers[currentQuestion.id],
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedAnswers[currentQuestion.id] = value!;
                                              });
                                            },
                                            visualDensity: const VisualDensity(
                                              horizontal: VisualDensity.minimumDensity,
                                              vertical: VisualDensity.minimumDensity,
                                            ),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          Flexible(
                                            child: Text(
                                              option,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
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
                        ],
                      ),
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
