import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/app/lms_app.dart';
import 'package:lms/core/di/app_di.dart';
import 'package:lms/core/flavors/flavors.dart';
import 'package:lms/core/utils/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );
  Bloc.observer = MyBlocObserver();
  await AppDi().init();
  runApp(const LmsApp());
}
