import 'package:flutter/material.dart';

import 'package:lms/l10n/app_localizations.dart';

extension LocaleExtension on BuildContext {
  AppLocalizations tr() {
    return AppLocalizations.of(this)!;
  }
}
