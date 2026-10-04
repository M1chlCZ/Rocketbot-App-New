import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserAgentProvider {
  static String? _cached;

  static Future<String> get() async {
    if (_cached != null) return _cached!;
    final info = await PackageInfo.fromPlatform();
    String platform;
    if (Platform.isAndroid) {
      final android = await DeviceInfoPlugin().androidInfo;
      platform =
          'Android ${android.version.release}; ${android.manufacturer} ${android.model}';
    } else if (Platform.isIOS) {
      final ios = await DeviceInfoPlugin().iosInfo;
      platform = 'iOS ${ios.systemVersion}; ${ios.utsname.machine}';
    } else {
      platform = Platform.operatingSystem;
    }
    _cached = '${info.appName}/${info.version} ($platform)';
    return _cached!;
  }
}
