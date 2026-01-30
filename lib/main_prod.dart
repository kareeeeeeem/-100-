import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lms/core/app/lms_app.dart';
import 'package:lms/core/flavors/flavors.dart';

void main() {
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );
  runApp(const LmsApp());
}
