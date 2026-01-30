import 'package:lms/core/constants/app_constants.dart';

enum AppLocale {
  english('en'),
  arabic('ar');

  final String lang;

  const AppLocale(this.lang);

  @override
  String toString() {
    return lang;
  }

  String countryCode() {
    return switch (this) {
      AppLocale.arabic => 'eg',
      AppLocale.english => 'us',
    };
  }

  static AppLocale fromString(String? locale) {
    if (locale?.contains(AppConstants.ar) == true) {
      return AppLocale.arabic;
    } else if (locale?.contains(AppConstants.en) == true) {
      return AppLocale.english;
    }
    throw Exception('Unsupported locale');
  }
}
