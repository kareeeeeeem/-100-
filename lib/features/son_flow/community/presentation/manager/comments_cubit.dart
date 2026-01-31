import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/community/domain/repository/community_repository.dart';
import 'package:lms/features/son_flow/community/data/model/comment_model.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommunityRepository repository;

  CommentsCubit(this.repository) : super(CommentsInitial());

  Future<void> loadComments(int courseId) async {
    emit(CommentsLoading());
    final result = await repository.getComments(courseId);
    if (result.isSuccess) {
      emit(CommentsLoaded(result.data ?? []));
    } else {
      emit(CommentsError(result.failure?.message ?? 'Unknown Error'));
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
      // If it's a top level comment, we might want to refresh the list or just append it
      // For now, let's refresh to get the full resource with user details etc.
      await loadComments(courseId);
    } else {
      emit(CommentsError(result.failure?.message ?? 'Failed to add comment'));
      // Restore previous state if needed
      emit(CommentsLoaded(currentComments));
    }
  }
}
