import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_image.dart';

class ProfileImageAndEdit extends StatelessWidget {
  const ProfileImageAndEdit({
    super.key,
    required this.imageSize,
    this.showEditIcon = true,
    this.onEditTap,
    this.imagePath,
    this.isUserProfile = true,
  });

  final double imageSize;
  final bool showEditIcon;
  final VoidCallback? onEditTap;
  final String? imagePath;
  final bool isUserProfile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.hardEdge,
          child: CustomImage(
            imagePath: imagePath,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
            isUserProfile: isUserProfile,
          ),
        ),
        if (showEditIcon)
          InkWell(
            onTap: onEditTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: imageSize * 0.3,
              height: imageSize * 0.3,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cF5F5F5,
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: imageSize * 0.15,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
