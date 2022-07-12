import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:rocketbot/screens/giveaway_screen.dart';
import 'package:rocketbot/screens/portfolio_page.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class MainMenuScreen extends StatefulWidget {
  static const String route = "menu";
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final _pageController = PageController(initialPage: 0);
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedPageIndex = index;
            });
          },
          children: <Widget>[
            PortfolioScreen(),
            GiveAwayScreen(),
          ]),
      bottomNavigationBar: SnakeNavigationBar.color(
        elevation: 0.0,
        height: 50.0,
        onTap: _onTappedBar,
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.red,
        backgroundColor: const Color(0xff394359),
        snakeViewColor: _getNavBarColor(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FlatCustomButton(
              width: 40,
              height: 40,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(0);
              },
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
              height: 40,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(0);
              },
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
              height: 40,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(1);
              },
              child: Image.asset("images/giveaway_inactive.png", width: 30, height: 30.0, fit: BoxFit.fitWidth, color: Colors.white),
            ),
            label: '',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 40,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(1);
              },
              child: Image.asset("images/giveaway.png", width: 30, height: 30.0, fit: BoxFit.fitWidth, color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: FlatCustomButton(
              width: 40,
              height: 40,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(2);
              },
              child: Image.asset("images/wallet_inactive.png", width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white),
            ),
            label: '',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 40,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(2);
              },
              child: Image.asset("images/wallet.png", width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: FlatCustomButton(
              width: 40,
              height: 40,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(3);
              },
              child: Image.asset("images/set_inactive.png", width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white),
            ),
            label: '',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 40,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(3);
              },
              child: Image.asset("images/set.png", width: 30, height: 30.0, fit: BoxFit.fitHeight, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _blockTouch(bool b) {
    setState(() {});
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedPageIndex = value;
    });

    _pageController.jumpToPage(value);
  }

  Color _getNavBarColor() {
    return const Color(0xFF9D9BFD);
  }
}
