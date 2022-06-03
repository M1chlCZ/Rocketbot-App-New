
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rocketbot/firebase_options.dart';
import 'package:rocketbot/screens/login_screen.dart';
import 'package:rocketbot/support/secure_storage.dart';
import 'Support/material_color_generator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/support/globals.dart' as globals;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
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
    _getSetLang();
    _setOptimalDisplayMode();
  }

  Locale? _locale;

  void setLocale(Locale value) {
    Future.delayed(Duration.zero, () {
      setState(() {
        _locale = value;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('images/receive_nav_icon.png'), context);
    precacheImage(const AssetImage('images/coin_nav_icon.png'), context);
    precacheImage(const AssetImage('images/send_nav_icon.png'), context);
    precacheImage(const AssetImage('images/price_frame.png'), context);
    precacheImage(const AssetImage('images/rocket_pin.png'), context);
    precacheImage(const AssetImage('images/rocketbot_logo.png'), context);
    precacheImage(const AssetImage('images/wave.png'), context);
    precacheImage(const AssetImage('images/logo_big.png'), context);
    precacheImage(const AssetImage('images/apple.png'), context);
  }

  void _getSetLang() async {
    String? ll = await SecureStorage.readStorage(key: globals.LOCALE_APP);
    if(ll != null) {
      Locale l;
      List<String> ls = ll.split('_');
      if(ls.length == 1) {
        l = Locale(ls[0], '');
      }else if (ls.length == 2) {
        l = Locale(ls[0], ls[1]);
      } else {
        l = Locale.fromSubtags(
            countryCode: ls[2], scriptCode: ls[1], languageCode: ls[0]);
      }
      setLocale(l);
    }
  }

  Future<void> _setOptimalDisplayMode() async {
    try {
      final List<DisplayMode> supported = await FlutterDisplayMode.supported;
      final DisplayMode active = await FlutterDisplayMode.active;

      final List<DisplayMode> sameResolution = supported.where(
              (DisplayMode m) => m.width == active.width
              && m.height == active.height).toList()..sort(
              (DisplayMode a, DisplayMode b) =>
              b.refreshRate.compareTo(a.refreshRate));

      final DisplayMode mostOptimalMode = sameResolution.isNotEmpty
          ? sameResolution.first
          : active;

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
      supportedLocales: const [
        Locale('en', ''),
        Locale('cs', 'CZ'),
        Locale('fi', 'FI')
      ],
      theme: ThemeData(
        fontFamily: "Montserrat",
        useMaterial3: true,
        canvasColor: const Color(0xFF1B1B1B),
        textTheme: TextTheme(
          headline1: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 28.0,
          ),
          headline2: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
          headline3: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
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
          subtitle2: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w400,
            fontSize: 10.0,
            fontStyle: FontStyle.italic
          ),
          bodyText1: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
          )
        ),
        primarySwatch: generateMaterialColor(Colors.white),
      ),
      home: const LoginScreen(),
    );
  }


}
