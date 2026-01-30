import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';

class CourseCategoriesListView extends StatefulWidget {
  const CourseCategoriesListView({super.key, required this.courses});

  final List<String> courses;

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
      itemBuilder: (context, index) {
        final course = widget.courses[index];
        bool isSelected = index == _selectedCategoryIndex;
        return GestureDetector(
          onTap: () {
            _updateSelectedCourseIndex(index);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.cF6F7FA,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                course,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.c9D9FA0,
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 10);
      },
      itemCount: widget.courses.length,
    );
  }
}
