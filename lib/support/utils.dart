import 'package:core_utils_kit/core_utils_kit.dart' as core_utils;
import 'package:flutter/cupertino.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:qr_scanner_kit/qr_scanner_kit.dart';

class Utils {
  static Future<bool> openLink(String? s) async {
    if (s == null) {
      return false;
    }
    try {
      return await core_utils.openLink(Uri.parse(s));
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static Future<String?> scanQR(BuildContext context) async {
    String? data;
    FocusScope.of(context).unfocus();
    await Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return QrScanner(
        onScan: (String s) {
          data = s;
        },
      );
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));
      if (data != null) {
        return data;
      } else {
        return null;
      }
  }

  static Future<bool> getTwoFactorStatic() async {
    try {
      RocketbotClient ci = RocketbotClient();
      Map<String, dynamic> m = await ci.get("/twofactor/check", pos: true, debug: false);
      return m['twoFactor'] as bool;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> check2FA(String s) async {
    try {
      RocketbotClient ci = RocketbotClient();
      Map<String, dynamic> m = await ci.post("/twofactor/auth", {"token": s}, pos: true, debug: false);
      return true;
    } catch (e) {
      return false;
    }
  }
}
