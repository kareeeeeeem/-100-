import 'package:lms/core/constants/cache_constants.dart';
import 'package:lms/core/service/cache_service.dart';
import 'package:lms/core/service/jwt_service.dart';

class JwtServiceServiceImpl implements JwtService {
  final CacheService cacheService;

  JwtServiceServiceImpl(this.cacheService);

  @override
  Future<void> saveAccessToken(String accessToken) async {
    await cacheService.set<String>(CacheConstants.accessTokenKey, accessToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await cacheService.get<String>(CacheConstants.accessTokenKey);
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await cacheService.set<String>(
      CacheConstants.refreshTokenKey,
      refreshToken,
    );
  }

  @override
  Future<String?> getRefreshToken() async {
    return await cacheService.get<String>(CacheConstants.refreshTokenKey);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await cacheService.get<String>(CacheConstants.accessTokenKey) !=
        null;
  }

  @override
  Future<void> deleteAccessToken() async {
    await cacheService.remove(CacheConstants.accessTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await cacheService.remove(CacheConstants.refreshTokenKey);
  }
@override
Future<void> saveUserType(String userType) async {
  await cacheService.set<String>('user_type', userType);
}

@override
Future<String?> getUserType() async {
  return await cacheService.get<String>('user_type');
}

@override
Future<void> saveUserName(String userName) async {
  await cacheService.set<String>('userName', userName);
}

@override
Future<String?> getUserName() async {
  return await cacheService.get<String>('userName');
}
}



