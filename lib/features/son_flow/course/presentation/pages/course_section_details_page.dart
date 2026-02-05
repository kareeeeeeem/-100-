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
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseSectionDetailsPage extends StatefulWidget {
  final SectionModel section;
  final int courseId;
  final List<SectionModel>? sections;
  final int? currentIndex;

  const CourseSectionDetailsPage({
    super.key,
    required this.section,
    required this.courseId,
    this.sections,
    this.currentIndex,
  });

  @override
  State<CourseSectionDetailsPage> createState() => _CourseSectionDetailsPageState();
}

class _CourseSectionDetailsPageState extends State<CourseSectionDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.section.title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'الدروس'),
            Tab(text: 'الامتحانات'),
            Tab(text: 'بث مباشر'),
            Tab(text: 'ملفات PDF'),
            Tab(text: 'تفاصيل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLessonsTab(context),
          _buildExamsTab(context),
          _buildLiveSessionsTab(context),
          _buildPDFsTab(context),
          _buildDetailsTab(context),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget? _buildBottomAction() {
    if (widget.sections == null || widget.currentIndex == null) return null;
    if (widget.currentIndex! >= widget.sections!.length - 1) return null;

    final nextSection = widget.sections![widget.currentIndex! + 1];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to next section
          context.pushReplacement(
            AppRoutes.courseSectionDetails,
            extra: {
              'section': nextSection,
              'courseId': widget.courseId,
              'sections': widget.sections,
              'currentIndex': widget.currentIndex! + 1,
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('القسم التالي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonsTab(BuildContext context) {
    final lessons = widget.section.lessons ?? [];
    if (lessons.isEmpty) {
      return _buildEmptyState('لا توجد دروس في هذا القسم حالياً', Icons.play_lesson_outlined);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: lessons.length,
      itemBuilder: (context, index) => _buildLessonItem(context, lessons[index], index),
    );
  }

  Widget _buildLessonItem(BuildContext context, Lesson lesson, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cF6F7FA,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
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
          lesson.title ?? 'درس ${index + 1}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          lesson.duration ?? '00:00',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: const Icon(Icons.lock_open_rounded, color: Colors.green, size: 20),
        onTap: () {
          Navigator.pop(context, lesson.videoUrl);
        },
      ),
    );
  }

  Widget _buildExamsTab(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ExamCubit>()..loadExamsBySection(widget.section.id.toString()),
      child: BlocBuilder<ExamCubit, ExamState>(
        builder: (context, state) {
          if (state is ExamLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExamsLoaded) {
            if (state.exams.isEmpty) {
              return _buildEmptyState('لا توجد امتحانات في هذا القسم', Icons.quiz_outlined);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.exams.length,
              itemBuilder: (context, index) => _buildExamItem(context, state.exams[index]),
            );
          } else if (state is ExamError) {
            return Center(child: Text('خطأ: ${state.message}', style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox();
        },
      ),
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
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.assignment_rounded, color: Colors.orange),
        ),
        title: Text(exam.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${exam.questionsCount ?? 0} سؤال • ${exam.durationMinutes ?? 0} دقيقة'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
        onTap: () {
          // Navigate to exam
        },
      ),
    );
  }

  Widget _buildLiveSessionsTab(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<LiveSessionCubit>()..loadSectionLiveSessions(widget.section.id.toString()),
      child: BlocBuilder<LiveSessionCubit, LiveSessionState>(
        builder: (context, state) {
          if (state is LiveSessionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LiveSessionsLoaded) {
            final all = [...state.sessions.availableNow, ...state.sessions.archived];
            if (all.isEmpty) {
              return _buildEmptyState('لا توجد جلسات بث مباشر حالياً', Icons.live_tv_rounded);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: all.length,
              itemBuilder: (context, index) => _buildLiveItem(context, all[index]),
            );
          } else if (state is LiveSessionError) {
            return Center(child: Text('خطأ: ${state.message}', style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox();
        },
      ),
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
        border: Border.all(color: isLive ? Colors.red.withOpacity(0.1) : Colors.transparent),
      ),
      child: ListTile(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
            Icon(
              isLive ? Icons.live_tv_rounded : Icons.play_circle_outline,
              color: isLive ? Colors.red : Colors.grey,
            ),
          ],
        ),
        title: Text(session.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(session.scheduledAt),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
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

  Widget _buildPDFsTab(BuildContext context) {
    return _buildEmptyState(
      'سيتم توفير ملفات PDF والملخصات لهذا القسم قريباً',
      Icons.picture_as_pdf_outlined,
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل القسم',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.c303030),
          ),
          const SizedBox(height: 15),
          _buildInfoRow(Icons.title, 'عنوان القسم', widget.section.title),
          _buildInfoRow(Icons.play_lesson_outlined, 'الدروس المتاحة', '${widget.section.lessons?.length ?? 0} درس'),
          _buildInfoRow(Icons.assignment_outlined, 'الامتحانات', '${widget.section.exams?.length ?? 0} امتحان'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'سيتم إضافة المزيد من التفاصيل والملاحظات الخاصة بكل سكشن هنا قريباً.',
                    style: TextStyle(fontSize: 14, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.c303030),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

