import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:lms/features/son_flow/home/data/model/course_details_cubit.dart';
import 'package:video_player/video_player.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/utils/app_svgs.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_cubit.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/course_comments_bottom_sheet.dart';

class SubscribedCourseDetailsPage extends StatefulWidget {
  final int courseId; // هنستقبله عشان نبعته للـ API
  const SubscribedCourseDetailsPage({super.key, required this.courseId});

  @override
  State<SubscribedCourseDetailsPage> createState() => _SubscribedCourseDetailsPageState();
}

class _SubscribedCourseDetailsPageState extends State<SubscribedCourseDetailsPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    // بنطلب بيانات الكورس أول ما الصفحة تفتح
    context.read<CourseDetailsCubit>().fetchCourseDetails(widget.courseId);
  }

  // ميثود تشغيل الفيديو بناءً على الرابط
  void _initializePlayer(String url) async {
    debugPrint('🎥 Playing Video URL: $url');
    await _videoPlayerController?.dispose();
    _chewieController?.dispose();

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoPlayerController!.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      aspectRatio: 16 / 9,
      allowFullScreen: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الدورة'),
      ),
      body: BlocConsumer<CourseDetailsCubit, CourseDetailsState>(
        listener: (context, state) {
          if (state is CourseDetailsSuccess) {
            // تشغيل أول درس تلقائياً لو موجود
            if (state.model.data?.lessons?.isNotEmpty ?? false) {
              _initializePlayer(state.model.data!.lessons![0].videoUrl ?? "");
            }
          }
        },
        builder: (context, state) {
          if (state is CourseDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourseDetailsSuccess) {
            final data = state.model.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- مشغل الفيديو ---
                    Container(
                      height: MediaQuery.sizeOf(context).height / 3,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25.15),
                      ),
                      child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                          ? Chewie(controller: _chewieController!)
                          : const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    ),
                    const SizedBox(height: 10),
                    
                    // --- عنوان الدورة ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            data?.title ?? '',
                            style: const TextStyle(fontSize: 18.86, fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                          onTap: () {
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
                          child: const Row(
                            children: [
                              Text('التعليقات', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                              SizedBox(width: 4),
                              Icon(Icons.comment_outlined, color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- قائمة الدروس (ديناميكية) ---
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cF6F7FA,
                        borderRadius: BorderRadius.circular(8.39),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data?.lessons?.length ?? 0,
                          separatorBuilder: (context, index) => const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final lesson = data!.lessons![index];
                            return InkWell(
                              onTap: () => _initializePlayer(lesson.videoUrl ?? ""),
                              child: Row(
                                spacing: 10,
                                children: [
                                  const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 50),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(lesson.title ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                        Text(lesson.duration ?? '', style: const TextStyle(fontSize: 12, color: AppColors.c8C8C8C)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
}