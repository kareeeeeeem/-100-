import 'package:flutter/material.dart';

import 'package:lms/core/app/lms_app.dart';
import 'package:lms/core/flavors/flavors.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:lms/core/di/app_di.dart';
import 'package:lms/firebase_options.dart';

const String appFlavor = 'prod';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  await AppDi().init();
  runApp(const LmsApp());
}
