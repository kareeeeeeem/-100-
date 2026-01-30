import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_svgs.dart';

class ComprehensiveTestAnswer extends StatelessWidget {
  const ComprehensiveTestAnswer({
    super.key,
    required this.answer,
    this.isCorrect,
  });

  final String answer;
  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: AppColors.c252836),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.c080101,
                ),
              ),
            ),
            Builder(
              builder: (context) {
                if (isCorrect == true) {
                  return AppSvgs.correctAnswer.svg(fit: BoxFit.scaleDown);
                } else if (isCorrect == false) {
                  return AppSvgs.wrongAnswer.svg(fit: BoxFit.scaleDown);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
