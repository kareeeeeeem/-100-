import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_image.dart';

class CategoryUIModel {
  final String name;
  final String? icon;
  final String? id;

  CategoryUIModel({required this.name, this.icon, this.id});
}

class CourseCategoriesListView extends StatefulWidget {
  const CourseCategoriesListView({super.key, required this.categories});

  final List<CategoryUIModel> categories;

  @override
  State<CourseCategoriesListView> createState() =>
      _CourseCategoriesListViewState();
}

class _CourseCategoriesListViewState extends State<CourseCategoriesListView> {
  int _selectedCategoryIndex = 0;

  void _updateSelectedCourseIndex(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.categories.length,
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        bool isSelected = index == _selectedCategoryIndex;
        return GestureDetector(
          onTap: () {
            _updateSelectedCourseIndex(index);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.cF6F7FA,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.c737373.withOpacity(0.1),
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   if (category.icon != null && category.icon!.isNotEmpty) ...[
                    CustomImage(
                      imagePath: category.icon!,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      // We can use color filter if needed for selected state, but icons are usually colored
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 13, // Slightly smaller for better fit
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.c303030,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
