import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_text_form_field.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_cubit.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_state.dart';

class CourseCommentsBottomSheet extends StatefulWidget {
  final int courseId;
  const CourseCommentsBottomSheet({super.key, required this.courseId});

  @override
  State<CourseCommentsBottomSheet> createState() => _CourseCommentsBottomSheetState();
}

class _CourseCommentsBottomSheetState extends State<CourseCommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            spacing: 10,
            children: [
              const Text(
                'التعليقات',
                style: TextStyle(
                  fontSize: 20.96,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              BlocBuilder<CommentsCubit, CommentsState>(
                builder: (context, state) {
                   if (state is CommentsLoaded) {
                     return Text(
                      '${state.comments.length}',
                      style: const TextStyle(
                        fontSize: 14.67,
                        fontWeight: FontWeight.w400,
                        color: AppColors.cAAAAAA,
                      ),
                    );
                   }
                   return const SizedBox();
                },
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  context.pop();
                },
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.c737373.withValues(alpha: 0.4)),
        Expanded(
          child: BlocBuilder<CommentsCubit, CommentsState>(
            builder: (context, state) {
              if (state is CommentsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CommentsError) {
                return Center(child: Text(state.message));
              }
              if (state is CommentsLoaded || state is CommentsAdding) {
                final comments = state is CommentsLoaded ? state.comments : (state as CommentsAdding).currentComments;
                if (comments.isEmpty) {
                  return const Center(child: Text('لا يوجد تعليقات بعد. كن أول من يعلق!'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        comment.userAvatar != null 
                          ? CircleAvatar(backgroundImage: NetworkImage(comment.userAvatar!), radius: 12)
                          : AppImages.blackWhite.image(width: 24, height: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    '${comment.userName} .',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    comment.createdAt,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.c737373.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                comment.commentText,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              DefaultTextStyle(
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.c111111,
                                ),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Row(
                                      spacing: 4,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${comment.dislikesCount}'),
                                        const Icon(
                                          Icons.thumb_down_alt_outlined,
                                          color: AppColors.c111111,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      spacing: 4,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${comment.likesCount}'),
                                        const Icon(
                                          Icons.thumb_up_alt_outlined,
                                          color: AppColors.c111111,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (comment.repliesCount > 0)
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      Text(
                                        '${comment.repliesCount} من الردود',
                                        style: const TextStyle(
                                          fontSize: 14.67,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.primary,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 14);
                  },
                  itemCount: comments.length,
                );
              }
              return const SizedBox();
            },
          ),
        ),
        Container(
          color: AppColors.primary,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 10,
              children: [
                AppImages.blackWhite.image(width: 24, height: 24),
                Expanded(
                  child: CustomTextFormField(
                    controller: _commentController,
                    fillColor: Colors.white,
                    hintText: 'اضف تعليق',
                    onTapOutside: (_) {},
                    suffix: IconButton(
                      icon: const Icon(Icons.send, color: AppColors.primary),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          context.read<CommentsCubit>().addComment(widget.courseId, _commentController.text);
                          _commentController.clear();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
