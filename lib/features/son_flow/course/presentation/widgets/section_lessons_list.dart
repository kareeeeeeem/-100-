
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/lessons/data/models/lessons_response_model.dart';
import 'package:lms/features/son_flow/lessons/domain/repositories/lessons_repository.dart';
import 'package:lms/features/son_flow/lessons/presentation/manager/lessons_cubit.dart';
import 'package:lms/features/son_flow/lessons/presentation/manager/lessons_state.dart';

class SectionLessonsList extends StatelessWidget {
  final String sectionId;
  final Function(Lesson) onItemBuilder;
  final bool isInitiallyExpanded;

  const SectionLessonsList({
    super.key, 
    required this.sectionId, 
    required this.onItemBuilder,
    this.isInitiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LessonsCubit(GetIt.instance<LessonsRepository>())..loadSectionLessons(sectionId),
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          if (state is LessonsLoading) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ));
          } else if (state is LessonsError) {
             // Silently fail or show empty if needed
             return const SizedBox();
          } else if (state is LessonsLoaded) {
            final lessons = state.lessons;
            if (lessons.isEmpty) return const SizedBox();

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
              itemCount: lessons.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) => onItemBuilder(lessons[index]),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
