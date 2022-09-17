import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'package:rocketbot/firebase_options.dart';
import 'package:rocketbot/screens/login_screen.dart';
import 'package:rocketbot/support/get_setup.dart';
import 'package:rocketbot/support/globals.dart' as globals;
import 'package:rocketbot/support/notification_helper.dart';
import 'package:rocketbot/support/secure_storage.dart';
import 'package:rocketbot/support/utils.dart';

import 'Support/material_color_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getSetup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firebaseMessaging = GetIt.I.get<FCM>();
  firebaseMessaging.setNotifications();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null && initialMessage.data['link'] != null) {
    Utils.openLink(initialMessage.data["dataLink"]);
  }

  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    final notification = message.data['notification'];
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState? of(BuildContext context) => context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _handleStuff();
  }

  Future<void> _handleStuff() async {
    String? s = await SecureStorage.readStorage(key: "nxgn");
    if (s == null) {
      await SecureStorage.deleteAll();
      await SecureStorage.writeStorage(key: "nxgn", value: "1");
    }

    _getSetLang();
    _setOptimalDisplayMode();
    _initAndroidColors();
  }

  Locale? _locale;

  void setLocale(Locale value) {
    Future.delayed(Duration.zero, () {
      setState(() {
        _locale = value;
      });
    });
  }



  void _initAndroidColors() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFF252F45),
          systemNavigationBarIconBrightness: Brightness.light));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('images/receive_nav_icon.png'), context);
    precacheImage(const AssetImage('images/coin_nav_icon.png'), context);
    precacheImage(const AssetImage('images/send_nav_icon.png'), context);
    precacheImage(const AssetImage('images/rocketbot_logo.png'), context);
    precacheImage(const AssetImage('images/logo_big.png'), context);
    precacheImage(const AssetImage('images/apple.png'), context);
  }

  void _getSetLang() async {
    String? ll = await SecureStorage.readStorage(key: globals.LOCALE_APP);
    if (ll != null) {
      Locale l;
      List<String> ls = ll.split('_');
      if (ls.length == 1) {
        l = Locale(ls[0], '');
      } else if (ls.length == 2) {
        l = Locale(ls[0], ls[1]);
      } else {
        l = Locale.fromSubtags(countryCode: ls[2], scriptCode: ls[1], languageCode: ls[0]);
      }
      setLocale(l);
    }
  }

  Future<void> _setOptimalDisplayMode() async {
    try {
      final List<DisplayMode> supported = await FlutterDisplayMode.supported;
      final DisplayMode active = await FlutterDisplayMode.active;

      final List<DisplayMode> sameResolution = supported.where((DisplayMode m) => m.width == active.width && m.height == active.height).toList()
        ..sort((DisplayMode a, DisplayMode b) => b.refreshRate.compareTo(a.refreshRate));

      final DisplayMode mostOptimalMode = sameResolution.isNotEmpty ? sameResolution.first : active;

      await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RocketBot',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: (locales, supportedLocales) {
        if (kDebugMode) {
          print('device locales=$locales supported locales=$supportedLocales');
        }

        for (Locale locale in locales!) {
          if (supportedLocales.contains(locale)) {
            if (kDebugMode) {
              print('supported');
            }
            return locale;
          }
        }
        return const Locale('en', '');
      },
      supportedLocales: const [Locale('en', ''), Locale('cs', 'CZ'), Locale('fi', 'FI')],
      theme: ThemeData(
        fontFamily: "Poppins",
        useMaterial3: true,
        canvasColor: const Color(0xFF252F45),
        textTheme: TextTheme(
            headline1: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24.0,
            ),
            headline2: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
            headline3: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
            ),
            headline4: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
            subtitle1: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 10.0,
            ),
            subtitle2: TextStyle(color: Colors.white.withOpacity(0.65), fontWeight: FontWeight.w400, fontSize: 10.0, fontStyle: FontStyle.italic),
            bodyText1: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
            bodyText2: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            )),
        primarySwatch: generateMaterialColor(Colors.white),
      ),
      home: const LoginScreen()
    );
  }
}
