import 'package:flutter/foundation.dart';

import 'package:lms/core/constants/app_locale.dart';
import 'package:lms/features/localization/domain/repository/localization_repository.dart';
import 'package:lms/features/localization/data/data_source/local/localization_local_service.dart';

class LocalizationRepositoryImpl implements LocalizationRepository {
  final LocalizationCacheService localizationLocalService;

  LocalizationRepositoryImpl(this.localizationLocalService);

  @override
  Future<AppLocale> getInitialLocale() async {
    try {
      final locale =
          await localizationLocalService.getInitialLocale() ??
          AppLocale.arabic.lang;
      return AppLocale.fromString(locale);
    } catch (e) {
      if (kDebugMode) {
        print('Error happened while getting saved locale: $e');
      }
      return AppLocale.arabic;
    }
  }

  @override
  void saveLocale(AppLocale locale) {
    try {
      localizationLocalService.saveLocale(locale.toString());
    } catch (e) {
      if (kDebugMode) {
        print('Error happened while saving locale: $e');
      }
    }
  }
}
