import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/features/son_flow/home/data/model/section_model.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_model.dart';
import 'package:lms/features/son_flow/live_sessions/data/models/live_session_model.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_state.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_state.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseSectionDetailsPage extends StatelessWidget {
  final SectionModel section;
  final int courseId;

  const CourseSectionDetailsPage({
    super.key,
    required this.section,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          section.title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildLessonsList(context),
            const SizedBox(height: 30),
            _buildExamsSection(context),
            const SizedBox(height: 30),
            _buildLiveSessionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.library_books_rounded, color: Colors.white, size: 40),
          const SizedBox(height: 16),
          Text(
            section.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'مدتوى القسم التعليمي وجلسات البث المباشر',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsList(BuildContext context) {
    final lessons = section.lessons ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.play_circle_fill, color: AppColors.primary),
            const SizedBox(width: 10),
            const Text(
              'الدروس التعليمية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              '${lessons.length} درس',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (lessons.isEmpty)
          _buildEmptyMessage('لا توجد دروس في هذا القسم حالياً')
        else
          ...lessons.map((l) => _buildLessonItem(context, l)),
      ],
    );
  }

  Widget _buildLessonItem(BuildContext context, Lesson lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cF6F7FA,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 30),
        ),
        title: Text(
          lesson.title ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          lesson.duration ?? '00:00',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: const Icon(Icons.lock_open_rounded, color: Colors.green, size: 20),
        onTap: () {
          // In a real app, this would probably navigate back and play the video
          // For now, we can show a message or use navigator pop with result
          Navigator.pop(context, lesson.videoUrl);
        },
      ),
    );
  }

  Widget _buildExamsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.quiz, color: Colors.orange),
            SizedBox(width: 10),
            Text(
              'الامتحانات والتقييمات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocProvider(
          create: (context) => GetIt.instance<ExamCubit>()..loadExamsBySection(section.id.toString()),
          child: BlocBuilder<ExamCubit, ExamState>(
            builder: (context, state) {
              if (state is ExamLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ExamsLoaded) {
                if (state.exams.isEmpty) return _buildEmptyMessage('لا توجد امتحانات في هذا القسم');
                return Column(
                  children: state.exams.map((e) => _buildExamItem(context, e)).toList(),
                );
              } else if (state is ExamError) {
                return Text('خطأ: ${state.message}', style: const TextStyle(color: Colors.red));
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExamItem(BuildContext context, ExamModel exam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: const Icon(Icons.assignment_rounded, color: Colors.orange),
        title: Text(exam.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${exam.questionsCount ?? 0} سؤال • ${exam.durationMinutes ?? 0} دقيقة'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
        onTap: () {
          // Navigate to exam
        },
      ),
    );
  }

  Widget _buildLiveSessionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.live_tv_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text(
              'البث المباشر',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocProvider(
          create: (context) => GetIt.instance<LiveSessionCubit>()..loadSectionLiveSessions(section.id.toString()),
          child: BlocBuilder<LiveSessionCubit, LiveSessionState>(
            builder: (context, state) {
              if (state is LiveSessionLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LiveSessionsLoaded) {
                final all = [...state.sessions.availableNow, ...state.sessions.archived];
                if (all.isEmpty) return _buildEmptyMessage('لا توجد جلسات بث مباشر حالياً');
                return Column(
                  children: all.map((s) => _buildLiveItem(context, s)).toList(),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLiveItem(BuildContext context, LiveSessionModel session) {
    final isLive = session.isLive == true || 
                   session.isLive?.toString() == 'true' || 
                   session.isLive?.toString() == '1';
                   
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLive ? Colors.red.withOpacity(0.05) : AppColors.cF6F7FA,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          Icons.circle,
          color: isLive ? Colors.red : Colors.grey,
          size: 12,
        ),
        title: Text(session.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(session.scheduledAt),
        trailing: Icon(
          isLive ? Icons.video_call : Icons.play_circle_outline,
          color: isLive ? Colors.red : Colors.grey,
        ),
        onTap: () async {
          if (session.liveUrl != null) {
            final uri = Uri.parse(session.liveUrl!);
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          }
        },
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        message,
        style: const TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
      ),
    );
  }
}
