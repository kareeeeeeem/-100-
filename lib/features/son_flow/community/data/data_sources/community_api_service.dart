import 'package:lms/features/son_flow/community/data/model/comment_model.dart';

abstract class CommunityApiService {
  Future<CommentResponseModel> getComments(int courseId);
  Future<CommentModel> postComment(int courseId, String comment, {int? parentId});
}
