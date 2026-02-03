import 'package:flutter/material.dart';
import 'package:lms/core/constants/app_locale.dart';
import 'package:lms/core/flavors/flavors.dart';
import 'package:lms/core/routing/app_router.dart';
import 'package:lms/core/themes/light_theme.dart';
import 'package:lms/l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_cubit.dart';

class LmsApp extends StatelessWidget {
  const LmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance<ProfileCubit>()..getProfileData(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false, // ضيف السطر ده هنا
        title: F.title,
        routerConfig: AppRouter().router,
        theme: lightTheme,
        locale: Locale(AppLocale.arabic.lang),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
