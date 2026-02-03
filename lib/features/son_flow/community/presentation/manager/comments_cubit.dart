import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/community/domain/repository/community_repository.dart';
import 'package:lms/features/son_flow/community/data/model/comment_model.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommunityRepository repository;

  CommentsCubit(this.repository) : super(CommentsInitial());

  Future<void> loadComments(int courseId, {bool showLoading = true}) async {
    if (showLoading) emit(CommentsLoading());
    final result = await repository.getComments(courseId);
    if (result.isSuccess) {
      emit(CommentsLoaded(result.data ?? []));
    } else {
      if (showLoading) {
        emit(CommentsError(result.failure?.message ?? 'Unknown Error'));
      } else {
        // If we didn't show loading, maybe just show a snackbar via listener in UI
        // or just stay in loaded state. For now, let's just emit error.
        emit(CommentsError(result.failure?.message ?? 'Unknown Error'));
      }
    }
  }

  Future<void> addComment(int courseId, String text, {int? parentId}) async {
    final currentState = state;
    List<CommentModel> currentComments = [];
    if (currentState is CommentsLoaded) {
      currentComments = currentState.comments;
    }
    
    emit(CommentsAdding(currentComments));
    
    final result = await repository.postComment(courseId, text, parentId: parentId);
    
    if (result.isSuccess) {
      // Refresh without showing the full-screen loading indicator
      await loadComments(courseId, showLoading: false);
    } else {
      emit(CommentsError(result.failure?.message ?? 'Failed to add comment'));
      // Restore previous state
      emit(CommentsLoaded(currentComments));
    }
  }
}
