import 'package:lms/core/constants/cache_constants.dart';
import 'package:lms/core/service/cache_service.dart';
import 'package:lms/features/localization/data/data_source/local/localization_local_service.dart';

class LocalizationCacheServiceImpl implements LocalizationCacheService {
  final CacheService cacheService;

  LocalizationCacheServiceImpl(this.cacheService);

  @override
  Future<String?> getInitialLocale() async {
    return await cacheService.get<String>(CacheConstants.localeKey);
  }

  @override
  void saveLocale(String locale) {
    cacheService.set<String>(CacheConstants.localeKey, locale);
  }
}
