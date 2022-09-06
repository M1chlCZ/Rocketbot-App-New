import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get_it/get_it.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screens/earnings_screen.dart';
import 'package:rocketbot/screens/giveaway_screen.dart';
import 'package:rocketbot/screens/portfolio_page.dart';
import 'package:rocketbot/screens/settings_screen.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/notification_helper.dart';
import 'package:rocketbot/widgets/button_flat.dart';

import '../models/user.dart';

class MainMenuScreen extends StatefulWidget {
  static const String route = "menu";

  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final NetInterface _interface = NetInterface();
  final _firebaseMessaging = GetIt.I.get<FCM>();
  final _pageController = PageController(initialPage: 0);
  int _selectedPageIndex = 0;
  bool _socialsOK = true;

  @override
  void initState() {
    _initializeLocalNotifications();
    _firebaseMessaging.setNotifications();
    super.initState();
    _getUserInfo();
  }

  gotoPreviousScreen() {
    setState(() {
      _selectedPageIndex = 0;
    });
    _pageController.animateToPage(_selectedPageIndex, duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
  }

  gotoNextScreen() {
      setState(() {
       _selectedPageIndex = 2;
      });
    _pageController.animateToPage(_selectedPageIndex, duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: PageView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedPageIndex = index;
              });
            },
            children: <Widget>[
              const PortfolioScreen(),
              GiveAwayScreen(
                prevScreen: gotoPreviousScreen,
                nextScreen: gotoNextScreen,
              ),
              // Container(), //TODO NFT SCREEN
              const EarningsScreen(),
              SettingsScreen(
                socials: _getUserInfo,
              ),
            ]),
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        elevation: 0.0,
        height: 60.0,
        onTap: _onTappedBar,
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape(
            centered: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        unselectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
        selectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.white,
        backgroundColor: const Color(0xff394359),
        snakeViewColor: _getNavBarColor(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            tooltip: 'Portfolio',
            icon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset(
                "images/home_inactive.png",
                width: 30,
                height: 30.0,
                fit: BoxFit.fitWidth,
                color: Colors.white,
              ),
            ),
            label: 'Home',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset(
                "images/home.png",
                color: Colors.white,
                width: 30,
                height: 30.0,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset("images/giveaway_inactive.png", width: 30, height: 30.0, fit: BoxFit.fitWidth, color: Colors.white),
            ),
            label: 'Games',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset("images/giveaway.png", width: 30, height: 30.0, fit: BoxFit.fitWidth, color: Colors.white),
            ),
          ),

          // BottomNavigationBarItem(
          //   icon: FlatCustomButton(
          //     width: 40,
          //     height: 30,
          //     radius: 10.0,
          //     color: Colors.transparent,
          //     child: Image.asset("images/mona.png", width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white30),
          //   ),
          //   label: 'NFT',
          //   activeIcon: FlatCustomButton(
          //     width: 40,
          //     height: 30,
          //     radius: 10.0,
          //     color: Colors.transparent,
          //     child: Image.asset("images/mona.png", width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white30),
          //   ),
          // ),
          BottomNavigationBarItem(
            icon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset("images/wallet_inactive.png", width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white),
            ),
            label: 'Earn',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset("images/wallet.png", width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset("images/set_inactive.png",
                  width: 30, height: 30.0, fit: BoxFit.fitWidth, color: _socialsOK ? Colors.white : const Color(0xFFF35656)),
            ),
            label: 'Settings',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset("images/set.png",
                  width: 30, height: 30.0, fit: BoxFit.fitWidth, color: _socialsOK ? Colors.white : const Color(0xFFF35656)),
            ),
          ),
        ],
      ),
    );
  }

  void _initializeLocalNotifications() async {
    if (Platform.isAndroid) {
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'rocket1', // id
        'Rocketbot Deposit/Withdrawal Info', // title
        description: 'This channel is used for transaction notifications.',
        // description
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
        ledColor: Colors.red,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(channel);

      AndroidNotificationChannel channel2 = const AndroidNotificationChannel(
        'rocket2', // id
        'Rocketbot Promotion', // title
        description: 'This channel is used for promotion.',
        // description
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
        ledColor: Colors.red,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(channel2);
    }
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_notification');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    Dialogs.openAlertBox(context, "Alert", payload!);
  }

  void _onSelectNotification(String? payload) {
    Dialogs.openAlertBox(context, "Alert", payload!);
  }

  void _onTappedBar(int value) {
    // if (value == 2) {
    //   _pageController.jumpToPage(_selectedPageIndex);
    //   return;
    // }
    setState(() {
      _selectedPageIndex = value;
    });

    _pageController.jumpToPage(value);
  }

  Color _getNavBarColor() {
    return const Color(0xFF9D9BFD);
  }

  void _getUserInfo() async {
    try {
      List<int> socials = [];
      final response = await _interface.get("User/Me");
      var d = User.fromJson(response);
      if (d.hasError == false) {
        for (var element in d.data!.socialMediaAccounts!) {
          socials.add(element.socialMedia!);
        }
        if (socials.isNotEmpty) {
          setState(() {
            _socialsOK = true;
          });
        } else {
          setState(() {
            _socialsOK = false;
          });
        }
      } else {
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
