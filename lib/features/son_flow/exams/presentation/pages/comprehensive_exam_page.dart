import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/custom_outlined_button.dart';
import 'package:lms/features/son_flow/exams/presentation/widgets/comprehensive_test_answer.dart';

class ComprehensiveExamPage extends StatefulWidget {
  const ComprehensiveExamPage({super.key});

  @override
  State<ComprehensiveExamPage> createState() => _ComprehensiveExamPageState();
}

class _ComprehensiveExamPageState extends State<ComprehensiveExamPage> {
  int _currentQuestionIndex = 0;

  void _nextQuestion() {
    final newIndex = (_currentQuestionIndex + 1).toDouble();
    setState(() {
      _currentQuestionIndex = clampDouble(newIndex, 0, 9).toInt();
    });
  }

  void _prevQuestion() {
    final newIndex = (_currentQuestionIndex - 1).toDouble();
    setState(() {
      _currentQuestionIndex = clampDouble(newIndex, 0, 9).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 10,
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
                                child: const Center(
                                  child: Text(
                                    'أي من العناصر التالية يمتلك أقل عدد من الإلكترونات غير المزدوجة في مدارات (d)؟',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.c252836,
                                    ),
                                    textAlign: TextAlign.center,
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
                                      '10/${_currentQuestionIndex + 1}',
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
                        const ComprehensiveTestAnswer(
                          answer: 'أ) النحاس',
                          isCorrect: true,
                        ),
                        const SizedBox(height: 10),
                        const ComprehensiveTestAnswer(answer: 'ب) الزنك'),
                        const SizedBox(height: 10),
                        const ComprehensiveTestAnswer(answer: 'ج) الكروم'),
                        const SizedBox(height: 10),
                        const ComprehensiveTestAnswer(answer: 'د) المنجنيز'),
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
                  CustomElevatedButton(
                    title: 'التالي',
                    height: 40,
                    isExpanded: false,
                    onPressed: _currentQuestionIndex <= 9
                        ? () {
                            _nextQuestion();
                          }
                        : null,
                  ),
                  CustomOutlinedButton(
                    title: 'السابق',
                    height: 40,
                    isExpanded: false,
                    onPressed: _currentQuestionIndex >= 0
                        ? () {
                            _prevQuestion();
                          }
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
}
