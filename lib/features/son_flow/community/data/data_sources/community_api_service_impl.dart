import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/community/data/data_sources/community_api_service.dart';
import 'package:lms/features/son_flow/community/data/model/comment_model.dart';

class CommunityApiServiceImpl implements CommunityApiService {
  final ApiService apiService;
  final JwtService jwtService;

  CommunityApiServiceImpl(this.apiService, this.jwtService);

  @override
  Future<CommentResponseModel> getComments(int courseId) async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.get(
      ApiConstants.courseComments(courseId),
      headers: {'Authorization': 'Bearer $token'},
    );
    return CommentResponseModel.fromJson(response);
  }

  @override
  Future<CommentModel> postComment(int courseId, String comment,
      {int? parentId}) async {
    final token = await jwtService.getAccessToken();
    final response = await apiService.post(
      ApiConstants.postComment,
      body: {
        'course_id': courseId,
        'comment': comment,
        if (parentId != null) 'parent_id': parentId,
      },
      headers: {'Authorization': 'Bearer $token'},
    );
    return CommentModel.fromJson(response['data'] ?? response);
  }
}
