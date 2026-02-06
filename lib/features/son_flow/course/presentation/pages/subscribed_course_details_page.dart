import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_cubit.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_model.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_image.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_router.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_cubit.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/course_comments_bottom_sheet.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_model.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_state.dart';
import 'package:lms/features/son_flow/home/data/model/section_model.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_cubit.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_state.dart';
import 'package:lms/features/son_flow/live_sessions/data/models/live_session_model.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/section_lessons_list.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/section_print_links_list.dart';
import 'package:lms/features/son_flow/live_sessions/domain/repositories/live_session_repository.dart';
import 'package:lms/features/son_flow/pdfs/presentation/manager/print_links_cubit.dart';
import 'package:lms/features/son_flow/pdfs/presentation/manager/print_links_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class SubscribedCourseDetailsPage extends StatefulWidget {
  final int courseId;
  const SubscribedCourseDetailsPage({super.key, required this.courseId});

  @override
  State<SubscribedCourseDetailsPage> createState() => _SubscribedCourseDetailsPageState();
}

class _SubscribedCourseDetailsPageState extends State<SubscribedCourseDetailsPage> with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubePlayerController;
  late TabController _tabController;
  bool _isYoutubeVideo = false;
  String? _currentVideoUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    context.read<CourseDetailsCubit>().fetchCourseDetails(widget.courseId);
  }

  void _initializePlayer(String url, {bool forcePlay = false}) async {
    if (url.isEmpty) {
      debugPrint('⚠️ _initializePlayer called with empty URL');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رابط الفيديو غير متوفر')));
      return;
    }
    if (url == _currentVideoUrl && !forcePlay) {
      debugPrint('ℹ️ Video already playing: $url');
      return;
    }
    
    debugPrint('🎬 Initializing player for: $url (Force: $forcePlay)');
    setState(() {
      _currentVideoUrl = url;
    });
    
    // Dispose previous players
    final oldVideoController = _videoPlayerController;
    final oldChewieController = _chewieController;
    final oldYoutubeController = _youtubePlayerController;

    _videoPlayerController = null;
    _chewieController = null;
    _youtubePlayerController = null;

    if (mounted) setState(() {}); // Force rebuild to show loading

    // Dispose in background to avoid blocking new playback
    Future.microtask(() async {
      try {
        await oldVideoController?.dispose();
        oldChewieController?.dispose();
        oldYoutubeController?.dispose();
      } catch (e) {
        debugPrint('⚠️ Error disposing video player: $e');
      }
    });

    try {
      // Check if URL is YouTube
      final videoId = YoutubePlayer.convertUrlToId(url);
      
      if (videoId != null) {
        // YouTube video
        _isYoutubeVideo = true;
        _youtubePlayerController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: false,
          ),
        );
      } else {
        // Regular video
        _isYoutubeVideo = false;
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
        await _videoPlayerController!.initialize();
        
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
          aspectRatio: 16 / 9,
          allowFullScreen: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.primary,
            handleColor: AppColors.primary,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.white.withOpacity(0.5),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error initializing video player: $e');
    }
    
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _youtubePlayerController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('محتوى الدورة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.comment_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                builder: (sheetContext) => BlocProvider.value(
                  value: context.read<CommentsCubit>()..loadComments(widget.courseId),
                  child: CourseCommentsBottomSheet(
                    courseId: widget.courseId,
                    isSubscribed: true,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CourseDetailsCubit, CourseDetailsState>(
        listener: (context, state) {
          // Auto-play removed as per user request
        },
        builder: (context, state) {
          if (state is CourseDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourseDetailsSuccess) {
            final data = state.model.data;
            if (data == null) return const Center(child: Text("لا توجد بيانات"));

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // --- Video Player Section (Sliver) ---
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height / 3.5,
                      decoration: const BoxDecoration(color: Colors.black),
                      child: (data.lessons?.isEmpty ?? true) && (data.sections?.isEmpty ?? true)
                          ? const Center(child: Text('لا توجد فيديوهات متاحة', style: TextStyle(color: Colors.white)))
                          : _currentVideoUrl == null
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_circle_outline, color: Colors.white, size: 48),
                                      SizedBox(height: 8),
                                      Text('اختر درساً للبدء', style: TextStyle(color: Colors.white, fontSize: 16)),
                                    ],
                                  ),
                                )
                              : _isYoutubeVideo && _youtubePlayerController != null
                                  ? YoutubePlayer(
                                      key: ValueKey(_currentVideoUrl),
                                      controller: _youtubePlayerController!,
                                      showVideoProgressIndicator: true,
                                      progressIndicatorColor: AppColors.primary,
                                      progressColors: ProgressBarColors(
                                        playedColor: AppColors.primary,
                                        handleColor: AppColors.primary,
                                      ),
                                    )
                                  : _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                                      ? Chewie(
                                          key: ValueKey(_currentVideoUrl),
                                          controller: _chewieController!,
                                        )
                                      : const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    ),
                  ),

                  // --- TabBar Section (Persistent Sliver) ---
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: AppColors.primary,
                          indicatorWeight: 3,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          tabs: const [
                            Tab(text: 'الدروس'),
                            Tab(text: 'البث المباشر'),
                            Tab(text: 'الامتحانات'),
                            Tab(text: 'ملفات PDF'),
                            Tab(text: 'تفاصيل'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildLessonsTab(data),
                  _buildLiveSessionsTab(data),
                  _buildExamsTab(data),
                  _buildPDFsTab(data),
                  _buildDetailsTab(data),
                ],
              ),
            );
          } else if (state is CourseDetailsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLessonsTab(CourseData data) {
    // If only global lessons, show them as a single list
    if (data.lessons != null && data.lessons!.isNotEmpty && (data.sections == null || data.sections!.isEmpty)) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: data.lessons!.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildLessonItem(data.lessons![index], index),
      );
    }
    
    // If we have sections, show them with collapsible headers
    if (data.sections != null && data.sections!.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.sections!.length,
        itemBuilder: (context, sIndex) {
          final section = data.sections![sIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, section, widget.courseId, sections: data.sections, currentIndex: sIndex),
              SectionLessonsList(
                sectionId: section.id.toString(),
                onItemBuilder: (lesson) => _buildLessonItem(lesson, data.lessons?.indexOf(lesson) ?? 0),
              ),
              const Divider(height: 30),
            ],
          );
        },
      );
    }
    
    return _buildEmptyState('لا توجد دروس متاحة حالياً', Icons.play_lesson_outlined);
  }

  Widget _buildLessonItem(Lesson lesson, int index) {
    final isPlaying = _currentVideoUrl == lesson.videoUrl;
    return InkWell(
      onTap: () => _initializePlayer(lesson.videoUrl ?? ""),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isPlaying ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPlaying ? AppColors.primary : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isPlaying ? AppColors.primary : AppColors.cF6F7FA,
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: isPlaying ? Colors.white : AppColors.primary,
                  size: 30,
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title ?? 'درس ${index + 1}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isPlaying ? FontWeight.bold : FontWeight.w500,
                      color: isPlaying ? AppColors.primary : AppColors.c303030,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        lesson.duration ?? '00:00',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isPlaying)
              const Icon(Icons.equalizer_rounded, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExamsTab(CourseData data) {
    final hasGlobalExams = data.exams != null && data.exams!.isNotEmpty;
    final hasSections = data.sections != null && data.sections!.isNotEmpty;
    final hasSectionsWithExams = data.sections?.any((s) => s.exams != null && s.exams!.isNotEmpty) ?? false;

    if (!hasGlobalExams && !hasSections) {
      return _buildEmptyState('لا توجد امتحانات لهذه الدورة', Icons.quiz_outlined);
    }

    if (hasSections && !hasGlobalExams) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.sections!.length,
        itemBuilder: (context, sIndex) {
          final section = data.sections![sIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, section, widget.courseId, sections: data.sections, currentIndex: sIndex),
              if (section.exams != null && section.exams!.isNotEmpty)
                ...section.exams!.map((e) => _buildExamItem(e))
              else
                SectionExamsList(
                  sectionId: section.id.toString(),
                  onExamItemBuilder: (exam) => _buildExamItem(exam),
                ),
              const Divider(height: 30),
            ],
          );
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.exams?.length ?? 0,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildExamItem(data.exams![index]),
    );
  }

  Widget _buildExamItem(ExamModel exam) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.assignment_rounded, color: Colors.orange, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.c303030),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${exam.questions?.length ?? exam.questionsCount ?? 0} سؤال | ${exam.duration ?? exam.durationMinutes ?? 0} دقيقة',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (exam.isCompleted == true) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check_circle, color: Colors.green, size: 14),
                      const SizedBox(width: 4),
                      const Text('مكتمل', style: TextStyle(fontSize: 11, color: Colors.green)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.pushNamed(AppRoutes.examTaking, extra: exam.id.toString());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('ابدأ'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(CourseData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'نبذة عن الدورة',
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.c303030),
          // ),
          // const SizedBox(height: 12),
          // Text(
          //   data.description ?? 'لا يوجد وصف متاح لهذه الدورة حالياً.',
          //   style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.c303030),
          // ),
          // const SizedBox(height: 25),
          const Text(
            'المدرس',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.c303030),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              ClipOval(
                child: CustomImage(
                  imagePath: data.instructor?.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  isUserProfile: true,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.instructor?.name ?? '',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.instructor?.bio ?? 'مدرس معتمد لدى أكاديمية 100',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildInfoRow(Icons.category_outlined, 'القسم', data.category ?? 'عام'),
          _buildInfoRow(Icons.timer_outlined, 'المدة الإجمالية', data.duration ?? '0 ساعة'),
          _buildInfoRow(Icons.play_lesson_outlined, 'عدد الدروس', '${data.totalLessonsCount ?? data.lessonsCount ?? data.lessons?.length ?? 0} درس'),
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

  Widget _buildPDFsTab(CourseData data) {
    if (data.sections == null || data.sections!.isEmpty) {
      return _buildEmptyState(
        'سيتم توفير ملفات PDF والملخصات قريباً',
        Icons.picture_as_pdf_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.sections!.length,
      itemBuilder: (context, sIndex) {
        final section = data.sections![sIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, section, widget.courseId, sections: data.sections, currentIndex: sIndex),
            SectionPrintLinksList(sectionId: section.id.toString()),
            const Divider(height: 30),
          ],
        );
      },
    );
  }

  Widget _buildLiveSessionsTab(CourseData data) {
    if (data.sections == null || data.sections!.isEmpty) {
      return _buildEmptyState('لا توجد ليفات متاحة لهذه الدورة', Icons.live_tv_outlined);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.sections!.length,
      itemBuilder: (context, sIndex) {
        final section = data.sections![sIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, section, widget.courseId, sections: data.sections, currentIndex: sIndex),
            SectionLiveSessionsList(
              sectionId: section.id.toString(),
              onItemBuilder: (session) => _buildLiveSessionItem(session),
            ),
            const Divider(height: 30),
          ],
        );
      },
    );
  }

  Widget _buildLiveSessionItem(LiveSessionModel session) {
    final bool isReallyLive = session.isLive == true || 
                             session.isLive?.toString() == 'true' || 
                             session.isLive?.toString() == '1';

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImage(
              imagePath: session.thumbnail,
              width: 80,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.c303030),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  session.stats.dateHuman.isNotEmpty ? session.stats.dateHuman : session.scheduledAt,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (session.isArchived)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('بث مسجل', style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold)),
                  )
                else if (isReallyLive)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('مباشر الآن 🔴', style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (session.isArchived && session.recordedUrl != null && session.recordedUrl!.isNotEmpty) {
                final url = Uri.parse(session.recordedUrl!);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              } else {
                _joinLiveSession(session.id);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(session.isArchived ? 'مشاهدة' : 'انضمام'),
          ),
        ],
      ),
    );
  }

  void _joinLiveSession(String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final result = await GetIt.instance<LiveSessionRepository>().joinSession(id);
      if (mounted) Navigator.pop(context);
      
      if (result.isSuccess) {
        final url = Uri.parse(result.data!.joinUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('لا يمكن فتح رابط الانضمام')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.failure?.message ?? 'خطأ في الانضمام')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ غير متوقع')),
        );
      }
    }
  }

  Widget _buildSectionHeader(BuildContext context, SectionModel section, int courseId, {List<SectionModel>? sections, int? currentIndex}) {
    return InkWell(
      onTap: () async {
        final result = await context.push(
          AppRoutes.courseSectionDetails,
          extra: {
            'section': section,
            'courseId': courseId,
            'sections': sections,
            'currentIndex': currentIndex,
          },
        );
        // If the user picked a video from the section page, play it here
        if (result is String && result.isNotEmpty) {
          _initializePlayer(result, forcePlay: true);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                section.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
          ],
        ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 50.0;
  @override
  double get maxExtent => 50.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class SectionLiveSessionsList extends StatefulWidget {
  final String sectionId;
  final Widget Function(LiveSessionModel) onItemBuilder;

  const SectionLiveSessionsList({
    super.key,
    required this.sectionId,
    required this.onItemBuilder,
  });

  @override
  State<SectionLiveSessionsList> createState() => _SectionLiveSessionsListState();
}

class _SectionLiveSessionsListState extends State<SectionLiveSessionsList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<LiveSessionCubit>()..loadSectionLiveSessions(widget.sectionId),
      child: BlocBuilder<LiveSessionCubit, LiveSessionState>(
        builder: (context, state) {
          if (state is LiveSessionLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          } else if (state is LiveSessionsLoaded) {
            final available = state.sessions.availableNow;
            final archived = state.sessions.archived;
            final all = [...available, ...archived];
            
            if (all.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Text('لا توجد ليفات في هذا القسم', style: TextStyle(color: Colors.grey, fontSize: 13)),
              );
            }
            return Column(
              children: all.map((s) => widget.onItemBuilder(s)).toList(),
            );
          } else if (state is LiveSessionError) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Text('خطأ في تحميل الليفات: ${state.message}', style: const TextStyle(color: Colors.red, fontSize: 12)),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class SectionExamsList extends StatefulWidget {
  final String sectionId;
  final Widget Function(ExamModel) onExamItemBuilder;

  const SectionExamsList({
    super.key,
    required this.sectionId,
    required this.onExamItemBuilder,
  });

  @override
  State<SectionExamsList> createState() => _SectionExamsListState();
}

class _SectionExamsListState extends State<SectionExamsList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ExamCubit>()..loadExamsBySection(widget.sectionId),
      child: BlocBuilder<ExamCubit, ExamState>(
        builder: (context, state) {
          if (state is ExamLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          } else if (state is ExamsLoaded) {
            final exams = state.exams;
            if (exams.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Text('لا توجد امتحانات في هذا القسم', style: TextStyle(color: Colors.grey, fontSize: 13)),
              );
            }
            return Column(
              children: exams.map((e) => widget.onExamItemBuilder(e)).toList(),
            );
          } else if (state is ExamError) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Text('خطأ في تحميل الامتحانات: ${state.message}', style: const TextStyle(color: Colors.red, fontSize: 12)),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}