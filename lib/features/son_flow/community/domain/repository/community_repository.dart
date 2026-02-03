import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/community/data/model/comment_model.dart';

abstract class CommunityRepository {
  Future<Result<List<CommentModel>>> getComments(int courseId);
  Future<Result<CommentModel>> postComment(int courseId, String comment, {int? parentId});
}
