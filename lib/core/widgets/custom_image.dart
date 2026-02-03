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
  final bool isUserProfile;

  const CustomImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.isUserProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    final String? trimmedPath = imagePath?.trim();
    
    if (trimmedPath == null || trimmedPath.isEmpty) {
      return _buildPlaceholder();
    }

    // Clean the path for detection
    String pathForDetection = trimmedPath;
    if (pathForDetection.startsWith('/')) {
      pathForDetection = pathForDetection.substring(1);
    }

    // Only treat as local asset if it's in our known local folders
    final bool isLocalAsset = pathForDetection.startsWith('assets/images/') || 
                             pathForDetection.startsWith('assets/svgs/');
    
    final bool isFullUrl = trimmedPath.startsWith('http://') || trimmedPath.startsWith('https://');

    // Build the final URL for network images
    String finalUrl = trimmedPath;
    if (!isLocalAsset) {
      if (isFullUrl) {
        // If it's a full URL from our domain but missing /storage/
        // Only add /storage/ if it's NOT an /assets/ path and NOT an /api/ path
        if (trimmedPath.contains('100-academy.com') && 
            !trimmedPath.contains('/storage/') && 
            !trimmedPath.contains('/api/') &&
            !trimmedPath.contains('/assets/')) {
          finalUrl = trimmedPath.replaceFirst('100-academy.com', '100-academy.com/storage');
        }
      } else {
        // It's a relative path
        String path = trimmedPath;
        if (path.startsWith('/')) {
          path = path.substring(1);
        }
        
        if (path.startsWith('storage/')) {
          path = path.substring('storage/'.length);
        }
        
        // Determine base URL: use /storage/ for most things, but not for /assets/
        if (path.startsWith('assets/')) {
          // Public assets (like slides) are at the domain root
          final String domain = ApiConstants.baseUrl.split('/api/')[0];
          finalUrl = '$domain/$path';
        } else {
          // Regular uploads are in /storage/
          finalUrl = '${ApiConstants.imageBaseUrl}/$path';
        }
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: isLocalAsset
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
        child: isUserProfile
            ? AppImages.userAvatar.image(
                width: width,
                height: height,
                fit: fit,
              )
            : Icon(
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
