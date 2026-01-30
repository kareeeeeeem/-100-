abstract class LocalizationCacheService {
  Future<String?> getInitialLocale();

  void saveLocale(String locale);
}
