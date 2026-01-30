import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';

class BottomNavBarIndicator extends StatelessWidget {
  const BottomNavBarIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Container(
          width: 16,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.79),
          ),
        ),
      ],
    );
  }
}
