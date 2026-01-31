import 'package:lms/core/models/result.dart';
import 'package:lms/core/errors/failures.dart';
import 'package:lms/features/son_flow/community/data/data_sources/community_api_service.dart';
import 'package:lms/features/son_flow/community/data/model/comment_model.dart';
import 'package:lms/features/son_flow/community/domain/repository/community_repository.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityApiService apiService;

  CommunityRepositoryImpl(this.apiService);

  @override
  Future<Result<List<CommentModel>>> getComments(int courseId) async {
    try {
      final response = await apiService.getComments(courseId);
      return Result.success(response.data);
    } catch (e) {
      return Result.error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<CommentModel>> postComment(int courseId, String comment,
      {int? parentId}) async {
    try {
      final response = await apiService.postComment(courseId, comment,
          parentId: parentId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> toggleFavorite(int courseId) async {
    try {
      final response = await apiService.toggleFavorite(courseId);
      return Result.success(response);
    } catch (e) {
      return Result.error(ServerFailure(e.toString()));
    }
  }
}
