import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_text_form_field.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_cubit.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_state.dart';

import 'package:get_it/get_it.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/core/widgets/custom_image.dart';
import 'package:lms/features/son_flow/community/data/model/comment_model.dart';

class CourseCommentsBottomSheet extends StatefulWidget {
  final int courseId;
  final bool isSubscribed;
  const CourseCommentsBottomSheet({
    super.key, 
    required this.courseId,
    this.isSubscribed = false,
  });

  @override
  State<CourseCommentsBottomSheet> createState() => _CourseCommentsBottomSheetState();
}

class _CourseCommentsBottomSheetState extends State<CourseCommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  String? _currentUserAvatar;
  int? _replyingToCommentId;
  String? _replyingToUserName;

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
  }

  Future<void> _loadUserAvatar() async {
    final avatar = await GetIt.instance<JwtService>().getUserAvatar();
    if (mounted) {
      setState(() {
        _currentUserAvatar = avatar;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _cancelReply() {
    setState(() {
      _replyingToCommentId = null;
      _replyingToUserName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            spacing: 12,
            children: [
              const Text(
                'التعليقات',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              BlocBuilder<CommentsCubit, CommentsState>(
                builder: (context, state) {
                  if (state is CommentsLoaded) {
                    return Text(
                      '(${state.comments.length})',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.c737373,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ],
          ),
        ),
        const Divider(height: 24),
        Expanded(
          child: BlocBuilder<CommentsCubit, CommentsState>(
            builder: (context, state) {
              if (state is CommentsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CommentsError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message, style: const TextStyle(color: Colors.red)),
                      TextButton(
                        onPressed: () => context.read<CommentsCubit>().loadComments(widget.courseId),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }
              final comments = state is CommentsLoaded 
                  ? state.comments 
                  : (state is CommentsAdding ? state.currentComments : []);

              if (comments.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد تعليقات بعد. كن أول من يعلق!',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: comments.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return _buildCommentItem(comment);
                },
              );
            },
          ),
        ),
        // Reply Preview Bar
        if (_replyingToCommentId != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                const Icon(Icons.reply, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الرد على ${_replyingToUserName}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                InkWell(
                  onTap: _cancelReply,
                  child: const Icon(Icons.cancel, size: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        // Comment Input Area
        Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
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
          child: widget.isSubscribed
              ? Row(
                  spacing: 12,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cF6F7FA,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CustomImage(
                        imagePath: _currentUserAvatar,
                        isUserProfile: true,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _commentController,
                        hintText: _replyingToCommentId != null ? 'اكتب ردك هنا...' : 'اضف تعليق...',
                        fillColor: AppColors.cF6F7FA,
                        suffix: IconButton(
                          icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                          onPressed: () {
                            final text = _commentController.text.trim();
                            if (text.isNotEmpty) {
                              context.read<CommentsCubit>().addComment(
                                widget.courseId, 
                                text,
                                parentId: _replyingToCommentId,
                              );
                              _commentController.clear();
                              _cancelReply();
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'يجب الاشتراك في الدورة لتتمكن من إضافة تعليق',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(CommentModel comment, {bool isReply = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Container(
              width: isReply ? 28 : 36,
              height: isReply ? 28 : 36,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: CustomImage(
                imagePath: comment.userAvatar,
                isUserProfile: true,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comment.userName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        comment.createdAt,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.commentText,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildActionIcon(Icons.thumb_up_alt_outlined, comment.likesCount.toString()),
                      const SizedBox(width: 16),
                      _buildActionIcon(Icons.thumb_down_alt_outlined, comment.dislikesCount.toString()),
                      const Spacer(),
                      if (!isReply)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _replyingToCommentId = comment.id;
                              _replyingToUserName = comment.userName;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'رد',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 48, top: 12),
            child: Column(
              children: comment.replies.map((reply) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCommentItem(reply, isReply: true),
              )).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
