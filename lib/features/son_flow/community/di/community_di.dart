import 'package:get_it/get_it.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/community/data/data_sources/community_api_service.dart';
import 'package:lms/features/son_flow/community/data/data_sources/community_api_service_impl.dart';
import 'package:lms/features/son_flow/community/data/repository/community_repository_impl.dart';
import 'package:lms/features/son_flow/community/domain/repository/community_repository.dart';
import 'package:lms/features/son_flow/community/presentation/manager/comments_cubit.dart';
import 'package:lms/features/son_flow/community/presentation/manager/favorite_cubit.dart';

class CommunityDi {
  final GetIt sl = GetIt.instance;

  Future<void> init() async {
    // 1. Register API Service
    sl.registerLazySingleton<CommunityApiService>(
      () => CommunityApiServiceImpl(sl<ApiService>(), sl<JwtService>()),
    );

    // 2. Register Repository
    sl.registerLazySingleton<CommunityRepository>(
      () => CommunityRepositoryImpl(sl<CommunityApiService>()),
    );

    // 3. Register Cubits
    sl.registerFactory(() => CommentsCubit(sl<CommunityRepository>()));
    sl.registerFactory(() => FavoriteCubit(sl<CommunityRepository>()));
  }
}
