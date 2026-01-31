import 'package:lms/features/son_flow/community/data/model/comment_model.dart';

abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<CommentModel> comments;
  CommentsLoaded(this.comments);
}

class CommentsAdding extends CommentsState {
  final List<CommentModel> currentComments;
  CommentsAdding(this.currentComments);
}

class CommentAdded extends CommentsState {
  final CommentModel comment;
  CommentAdded(this.comment);
}

class CommentsError extends CommentsState {
  final String message;
  CommentsError(this.message);
}
