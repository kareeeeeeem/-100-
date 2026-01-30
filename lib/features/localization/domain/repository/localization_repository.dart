import 'package:lms/core/constants/app_locale.dart';

abstract class LocalizationRepository {
  Future<AppLocale> getInitialLocale();

  void saveLocale(AppLocale locale);
}
