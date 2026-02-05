import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_image.dart';
import 'package:lms/features/parent_flow/data/models/child_model.dart';

class ChildCard extends StatelessWidget {
  final ChildModel child;
  final VoidCallback onTap;

  const ChildCard({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomImage(
              imagePath: child.avatar,
              fit: BoxFit.cover,
              isUserProfile: true,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              child.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.c303030,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
