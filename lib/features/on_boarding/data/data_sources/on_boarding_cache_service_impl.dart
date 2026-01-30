import 'package:lms/core/constants/cache_constants.dart';
import 'package:lms/core/service/cache_service.dart';
import 'package:lms/features/on_boarding/data/data_sources/on_boarding_cache_service.dart';

class OnBoardingCacheServiceImpl implements OnBoardingCacheService {
  final CacheService cacheService;

  OnBoardingCacheServiceImpl(this.cacheService);

  @override
  Future<void> completeOnBoarding() async {
    cacheService.set(CacheConstants.onBoardingKey, true);
  }

  @override
  Future<bool?> isOnBoardingCompleted() async {
    return await cacheService.get<bool>(CacheConstants.onBoardingKey);
  }
}
