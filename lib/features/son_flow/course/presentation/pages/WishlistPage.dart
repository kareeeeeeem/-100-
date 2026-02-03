import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_image.dart';
import 'package:lms/features/son_flow/course/presentation/pages/WishlistCubit.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.instance<WishlistCubit>()..getWishlist(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('قائمة المفضلة', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            if (state is WishlistLoaded || state is WishlistToggleSuccess) {
              final courses = (state is WishlistLoaded)
                  ? state.courses
                  : (state as WishlistToggleSuccess).courses;

              if (courses.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = courses[index];
                  return _buildFavoriteItem(context, item);
                },
              );
            }

            if (state is WishlistError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<WishlistCubit>().getWishlist(),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text("إعادة المحاولة", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              );
            }

            return _buildEmptyState(context);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "قائمة المفضلة فارغة حالياً",
            style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            "ابدأ بإضافة الدورات التي تعجبك لتجدها هنا لاحقاً",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.sonHome),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("استكشاف الدورات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, dynamic item) {
    // استخراج البيانات مع التعامل مع الاحتمالات المختلفة للـ keys
    final String title = item['title'] ?? item['course_name'] ?? item['name'] ?? "بدون عنوان";
    final String thumbnail = item['thumbnail'] ?? item['image'] ?? item['course_image'] ?? "";
    final String instructor = item['instructor']?['name'] ?? item['instructor_name'] ?? "";
    final dynamic priceData = item['price'];
    final String price = priceData is Map ? (priceData['label'] ?? "") : (priceData?.toString() ?? "");
    
    final dynamic rawId = item['id'] ?? item['course_id'];
    final int id = rawId is int ? rawId : (int.tryParse(rawId?.toString() ?? '') ?? 0);

    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.courseDetails, extra: id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة الكورس
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
              child: SizedBox(
                width: 100,
                height: 100,
                child: CustomImage(
                  imagePath: thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // تفاصيل الكورس
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (instructor.isNotEmpty)
                      Text(
                        "أ. $instructor",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (price.isNotEmpty)
                          Text(
                            price,
                            style: const TextStyle(
                              color: AppColors.c589B6E,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // زر الحذف من المفضلة
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => context.read<WishlistCubit>().toggleFavorite(id),
            ),
          ],
        ),
      ),
    );
  }
}