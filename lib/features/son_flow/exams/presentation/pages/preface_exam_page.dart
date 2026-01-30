import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/custom_outlined_button.dart';

class PrefaceExamPage extends StatefulWidget {
  const PrefaceExamPage({super.key});

  @override
  State<PrefaceExamPage> createState() => _PrefaceExamPageState();
}

class _PrefaceExamPageState extends State<PrefaceExamPage> {
  int _currentQuestionIndex = 0;

  void _updateCurrentQuestionIndex(int index) {
    setState(() {
      _currentQuestionIndex = index;
    });
  }

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
                        children: List.generate(10, (index) {
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
                      spacing: 10,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: 'سؤال 1 : ',
                            children: [
                              TextSpan(
                                text:
                                    'ما هي الادوات المستخدمه في تصميم الواجهات',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Column(
                          children: [
                            RadioGroup(
                              onChanged: (_) {},
                              child: const Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio.adaptive(
                                          value: false,
                                          visualDensity: VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Flexible(
                                          child: Text(
                                            'فيجما',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio.adaptive(
                                          value: false,
                                          visualDensity: VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Flexible(
                                          child: Text(
                                            'فوتوشوب',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio.adaptive(
                                          value: false,
                                          visualDensity: VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Flexible(
                                          child: Text(
                                            'اليستريتور',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio.adaptive(
                                          value: false,
                                          visualDensity: VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Flexible(
                                          child: Text(
                                            'اوتوكاد',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      spacing: 10,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: 'سؤال 2 : ',
                            children: [
                              TextSpan(
                                text:
                                    'ما هي الادوات المستخدمه في تصميم الواجهات',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Column(
                          children: [
                            RadioGroup(
                              onChanged: (_) {},
                              child: const Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio.adaptive(
                                          value: false,
                                          visualDensity: VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Flexible(
                                          child: Text(
                                            'فيجما',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio.adaptive(
                                          value: false,
                                          visualDensity: VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Flexible(
                                          child: Text(
                                            'فوتوشوب',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio.adaptive(
                                          value: false,
                                          visualDensity: VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Flexible(
                                          child: Text(
                                            'اليستريتور',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio.adaptive(
                                          value: false,
                                          visualDensity: VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Flexible(
                                          child: Text(
                                            'اوتوكاد',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
