import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:lms/core/service/device_info_service.dart';

class DeviceInfoServiceImpl implements DeviceInfoService {
  final DeviceInfoPlugin deviceInfoPlugin;

  DeviceInfoServiceImpl(this.deviceInfoPlugin);

  @override
  Future<String?> getDeviceId() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return androidDeviceInfo.id;
    }
    return null;
  }
}
