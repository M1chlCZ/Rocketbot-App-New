import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rocketbot/NetInterface/interface.dart';
import 'package:rocketbot/support/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String getUTC() {
    var dateTime = DateTime.now();
    var date = DateFormat('yyyy-MM-dd').format(dateTime);
    var dateZero = "$date 00:00:00";
    var val = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.parse(dateZero));
    var offset = dateTime.timeZoneOffset;
    var hours = offset.inHours > 0 ? offset.inHours : 1; // For fixing divide by 0
    if (!offset.isNegative) {
      val = "$val+${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    } else {
      val = "$val-${(-offset.inHours).toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    }
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(val));
  }

  static String convertDate(String? date) {
    DateTime dt = DateTime.parse(date!);
    final dateNow = DateTime.now();
    DateTime? fix;
    if (dateNow.timeZoneOffset.isNegative) {
      fix = dt.subtract(Duration(hours: dateNow.timeZoneOffset.inHours));
    } else {
      fix = dt.add(Duration(hours: dateNow.timeZoneOffset.inHours));
    }
    return DateFormat.yMd(Platform.localeName).add_jm().format(fix).toString();
    // final sec = fix.difference(dateNow);
    // var days = sec.inDays;
    // var hours = sec.inHours % 24;
    // var minutes = sec.inMinutes % 60;
    // var seconds = sec.inSeconds % 60;
    // return "${days < 10 ? "0$days" : "$days"}d:${hours < 10 ? "0$hours" : "$hours"}h:${minutes < 10 ? "0$minutes" : "$minutes"}m:${seconds < 10 ? "0$seconds" : "$seconds"}s";
  }

  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }

  static void openLink(String? s) async {
    var succ = false;
    if (s != null) {
      try {
        succ = await launchUrl(Uri.parse(s), mode: LaunchMode.externalNonBrowserApplication);
      } catch (e) {
        debugPrint(e.toString());
      }
      if (!succ) {
        try {
          succ = await launchUrl(Uri.parse(s), mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      if (!succ) {
        try {
          await launchUrl(Uri.parse(s), mode: LaunchMode.platformDefault);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));

  static Future<String?> scanQR(BuildContext context) async {
    String? data;
    FocusScope.of(context).unfocus();
    await Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return QScanWidget(
        scanResult: (String s) {
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
      NetInterface ci = NetInterface();
      Map<String, dynamic> m = await ci.get("/twofactor/check", pos: true, debug: false);
      return m['twoFactor'] as bool;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> check2FA(String s) async {
    try {
      NetInterface ci = NetInterface();
      Map<String, dynamic> m = await ci.post("/twofactor/auth", {"token": s}, pos: true, debug: false);
      return true;
    } catch (e) {
      return false;
    }
  }
}
