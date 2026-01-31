import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/constants/api_constants.dart';

class CustomImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double borderRadius;

  const CustomImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    final String? trimmedPath = imagePath?.trim();
    
    if (trimmedPath == null || trimmedPath.isEmpty) {
      return _buildPlaceholder();
    }

    final bool isAsset = trimmedPath.startsWith('assets/');
    final bool isFullUrl = trimmedPath.startsWith('http://') || trimmedPath.startsWith('https://');
    
    // Build the final URL for network images
    String finalUrl = trimmedPath;
    if (!isAsset && !isFullUrl) {
      // It's a relative path, prepend the base URL
      // Ensure we don't have double slashes
      if (trimmedPath.startsWith('/')) {
        finalUrl = '${ApiConstants.imageBaseUrl}$trimmedPath';
      } else {
        finalUrl = '${ApiConstants.imageBaseUrl}/$trimmedPath';
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: isAsset
          ? Image.asset(
              trimmedPath,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
            )
          : Builder(
              builder: (context) {
                // Debug: Print the URL being loaded
                print('🖼️ CustomImage loading: $finalUrl');
                return Image.network(
                  finalUrl,
                  width: width,
                  height: height,
                  fit: fit,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildLoading();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('❌ CustomImage error loading: $finalUrl');
                    print('   Error: $error');
                    return _buildPlaceholder();
                  },
                );
              },
            ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey[400],
          size: (width != null && width!.isFinite) ? width! * 0.5 : 50,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
