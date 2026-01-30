import 'package:lms/core/constants/app_locale.dart';
import 'package:lms/features/localization/presentation/locale_provider.dart';

class LocalProviderImpl implements LocaleProvider {
  final Stream<AppLocale> localeStream;

  AppLocale _currentLocale = AppLocale.english;

  LocalProviderImpl(this.localeStream, AppLocale initialLocale) {
    _currentLocale = initialLocale;
    localeStream.listen((locale) {
      _currentLocale = locale;
    });
  }

  @override
  String getInitialLocale() => _currentLocale.toString();
}
