import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get_it/get_it.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screens/earnings_screen.dart';
import 'package:rocketbot/screens/giveaway_screen.dart';
import 'package:rocketbot/screens/launchpad_screen.dart';
import 'package:rocketbot/screens/portfolio_page.dart';
import 'package:rocketbot/screens/settings_screen.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/notification_helper.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/button_flat.dart';

import '../models/user.dart';

class MainMenuScreen extends StatefulWidget {
  static const String route = "menu";

  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final NetInterface _interface = NetInterface();
  final _firebaseMessaging = GetIt.I.get<FCM>();
  final _pageController = PageController(initialPage: 0);
  final _appLinks = AppLinks();
  int _selectedPageIndex = 0;
  bool _socialsOK = true;
  double widthScreen = 0.0;

  @override
  void initState() {
    _firebaseMessaging.setNotifications();
    super.initState();
    _getUserInfo();
    FlutterAppBadger.removeBadge();
    _appLinks.uriLinkStream.listen((uri) {
      if (uri.queryParameters.containsKey("auth")) {
        _webToken(uri.queryParameters["auth"]!);
      } else {
        print("fail to launch website");
      }
    });
  }

  gotoPreviousScreen({bool art = false}) {
    setState(() {
      _selectedPageIndex = art ? 1 : 0;
    });
    _pageController.animateToPage(_selectedPageIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
  }

  gotoNextScreen({bool art = false}) {
    setState(() {
      _selectedPageIndex = art ? 3 : 2;
    });
    _pageController.animateToPage(_selectedPageIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
  }

  gotoLaunchPreviousScreen() {
    setState(() {
      _selectedPageIndex = 1;
    });
    _pageController.animateToPage(_selectedPageIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
  }

  gotoLaunchNextScreen() {
    setState(() {
      _selectedPageIndex = 3;
    });
    _pageController.animateToPage(_selectedPageIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
  }

  bool c = false;

  _webToken(String webtoken) async {
    if (c) return;
    try {
      Dialogs.openWaitBox(context);
      await _interface.post("/user/confirm", {"auth": webtoken}, web: true, debug: true);
      await Future.delayed(const Duration(seconds: 3), () {
        // _getUserInfo();
      });
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Launchpad login successful")));
      Utils.openLink("https://rocket.art");
      c = false;
    } catch (e) {
      c = false;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
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
              LaunchpadScreen(
                prevScreen: gotoLaunchPreviousScreen,
                nextScreen: gotoLaunchNextScreen,
              ),
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
          color: Colors.red,
          fontSize: 11.0,
        ),
        selectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 11.0,
        ),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
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
              child: Image.asset("images/giveaway_inactive.png",
                  width: 30, height: 30.0, fit: BoxFit.fitWidth, color: Colors.white),
            ),
            label: 'Games',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset("images/giveaway.png",
                  width: 30, height: 30.0, fit: BoxFit.fitWidth, color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "images/ra_inactive.png",
              width: 60,
              height: 30.0,
              fit: BoxFit.fitWidth,
            ),
            label: 'Rocket.art',
            activeIcon: Image.asset(
              "images/ra_active.png",
              width: 60,
              height: 30.0,
              fit: BoxFit.fitWidth,
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
              child: Image.asset("images/wallet_inactive.png",
                  width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white),
            ),
            label: 'Earn',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child:
                  Image.asset("images/wallet.png", width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset("images/set_inactive.png",
                  width: 30,
                  height: 30.0,
                  fit: BoxFit.fitWidth,
                  color: _socialsOK ? Colors.white : const Color(0xFFF35656)),
            ),
            label: 'Settings',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              child: Image.asset("images/set.png",
                  width: 30,
                  height: 30.0,
                  fit: BoxFit.fitWidth,
                  color: _socialsOK ? Colors.white : const Color(0xFFF35656)),
            ),
          ),
        ],
      ),
    );
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
