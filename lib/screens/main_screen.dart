import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/deposit_address.dart';
import 'package:rocketbot/models/pos_coins_list.dart';
import 'package:rocketbot/netInterface/interface.dart';
import 'package:rocketbot/screenPages/coin_page.dart';
import 'package:rocketbot/screenpages/deposit_page.dart';
import 'package:rocketbot/screenpages/send_page.dart';
import 'package:rocketbot/screenpages/staking_page.dart';

import '../component_widgets/button_neu.dart';
import '../screens/portfolio_page.dart';

class MainScreen extends StatefulWidget {
  final CoinBalance coinBalance;
  final List<CoinBalance>? listCoins;
  final PosCoinsList? posCoinsList;
  final VoidCallback refreshList;

  const MainScreen({
    Key? key,
    required this.coinBalance,
    this.listCoins,
    this.posCoinsList,
    required this.refreshList,
  }) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final NetInterface _interface = NetInterface();
  final _portfolioKey = GlobalKey<PortfolioScreenState>();
  final _coinKey = GlobalKey<CoinScreenState>();
  final _depositKey = GlobalKey<DepositPageState>();
  final _sendKey = GlobalKey<SendPageState>();
  final _pageController = PageController(initialPage: 1);
  String? _depositAddr;
  String? _posDepositAddr;
  int _selectedPageIndex = 1;
  List<CoinBalance>? _lc;
  late Coin _coinActive;
  double _free = 0.0;
  bool _posCoin = false;

  @override
  void initState() {
    super.initState();
    _coinActive = widget.coinBalance.coin!;
    _free = widget.coinBalance.free!;
    _lc = widget.listCoins!;
    _checkPosCoin(_coinActive);
    _getDepositAddr();

    // _bloc = BalancesBloc();
    // _priceBlock = CoinPriceBloc("merge");
  }

  @override
  void dispose() {
    _pageController.dispose();
    // _bloc!.dispose();
    // _priceBlock!.dispose();
    super.dispose();
  }

  void goBack() {
    setState(() {});
  }

  void _checkPosCoin(Coin? c) {
    try {
      final indexPos = widget.posCoinsList!.coins!.indexWhere((element) => element.idCoin! == c?.id!);
      indexPos != -1 ? _posCoin = true : _posCoin = false;
      if (indexPos != -1) {
        _posDepositAddr = widget.posCoinsList!.coins![indexPos].depositAddr!;
      } else {
        _posDepositAddr = null;
      }
      setState(() {});
    } catch (e) {
      _posDepositAddr = null;
      debugPrint(e.toString());
    }
  }

  void _setActiveCoin(Coin? c) async {
    final index = _lc!.indexWhere((element) => element.coin == c);
    _free = _lc![index].free!;
    _coinKey.currentState?.changeFree(_free);
    _coinActive = c!;
    _checkPosCoin(_coinActive);
    _coinKey.currentState?.setAddr(_posDepositAddr);
    _depositKey.currentState?.changeStuff(_coinActive, _depositAddr);
    await _getDepositAddr();
    setState(() {});
  }

  void getBalances(List<CoinBalance>? lc) {
    _lc = lc;
  }

  void _changeFree(double free) {
    _free = free;
    widget.refreshList();
  }

  void changeCoinName(Coin? s) {
    _lc = _portfolioKey.currentState!.getList();
    setState(() {
      _coinActive = s!;
    });
  }

  _getDepositAddr() async {
    Map<String, dynamic> request = {
      "coinId": _coinActive.id!,
    };
    try {
      final response = await _interface.post("Transfers/CreateDepositAddress", request);
      var d = DepositAddress.fromJson(response);
      setState(() {
        _depositAddr = d.data!.address!;
      });
    } catch (e) {
      _depositAddr = "";
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _gotoStaking() {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return StakingPage(
        setActiveCoin: _setActiveCoin,
        changeFree: _changeFree,
        depositAddress: _depositAddr,
        depositPosAddress: _posDepositAddr,
        activeCoin: _coinActive,
        coinBalance: _lc!.singleWhere((element) => element.coin!.id! == _coinActive.id!),
        allCoins: _lc,
        free: _free,
        goBack: goBack,
        blockTouch: _blockTouch,
      );
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedPageIndex = index;
              });
            },
            children: <Widget>[
              DepositPage(
                key: _depositKey,
                coin: _coinActive,
                free: _free,
                depositAddr: _depositAddr,
              ),
              CoinScreen(
                  key: _coinKey,
                  setActiveCoin: _setActiveCoin,
                  changeFree: _changeFree,
                  activeCoin: _coinActive,
                  allCoins: _lc,
                  goBack: goBack,
                  goToStaking: _gotoStaking,
                  posDepositAddr: _posDepositAddr,
                  blockTouch: _blockTouch,
                  free: _free),
              SendPage(
                key: _sendKey,
                changeFree: _changeFree,
                coinActive: _coinActive,
                free: _free,
              ),
            ]),
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        elevation: 2.0,
        onTap: _onTappedBar,
        behaviour: SnakeBarBehaviour.pinned,
        snakeShape: SnakeShape(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.amber,
        backgroundColor: Theme.of(context).canvasColor,
        snakeViewColor: _getNavBarColor(),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: NeuButton(
              width: 45,
              height: 45,
              onTap: () {
                _onTappedBar(0);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Image.asset(
                  "images/receive_nav_icon.png",
                  width: 25,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            backgroundColor: Colors.amber,
            label: '',
            activeIcon: NeuButton(
              width: 45,
              height: 45,
              onTap: () {
                _onTappedBar(0);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Image.asset(
                  "images/receive_nav_icon.png",
                  color: const Color(0xFF15D37A),
                  width: 25,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: NeuButton(
              width: 45,
              height: 45,
              onTap: () {
                _onTappedBar(1);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Image.asset(
                  "images/coin_nav_icon.png",
                  color: Colors.white,
                  width: 34,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            label: '',
            activeIcon: NeuButton(
              width: 45,
              height: 45,
              onTap: () {
                _onTappedBar(1);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Image.asset(
                  "images/coin_nav_icon.png",
                  width: 34,
                  fit: BoxFit.fitWidth,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          // BottomNavigationBarItem(
          //   icon: NeuButton(
          //     width: 45,
          //     height: 45,
          //     onTap: () {
          //       if (_posCoin) {
          //         _onTappedBar(2);
          //       }
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.only(bottom: 0.0),
          //       child: Image.asset(
          //         "images/staking_icon.png",
          //         width: 38,
          //         fit: BoxFit.fitWidth,
          //         color: _posCoin ? Colors.white : Colors.white30,
          //       ),
          //     ),
          //   ),
          //   label: '',
          //   activeIcon: NeuButton(
          //     width: 45,
          //     height: 45,
          //     onTap: () {
          //       if (_posCoin) {
          //         _onTappedBar(2);
          //       }
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.only(bottom: 0.0),
          //       child: Image.asset(
          //         "images/staking_icon.png",
          //         color: const Color(0xFFFDCB29),
          //         width: 38,
          //         fit: BoxFit.fitWidth,
          //       ),
          //     ),
          //   ),
          // ),
          BottomNavigationBarItem(
            icon: NeuButton(
              width: 45,
              height: 45,
              onTap: () {
                _onTappedBar(2);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Image.asset(
                  "images/send_nav_icon.png",
                  width: 25,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            label: '',
            activeIcon: NeuButton(
              width: 45,
              height: 45,
              onTap: () {
                _onTappedBar(2);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Image.asset(
                  "images/send_nav_icon.png",
                  color: const Color(0xFFEB3A13),
                  width: 25,
                  fit: BoxFit.fitWidth,
                ),
              ),
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
    _pageController.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.easeInOutCirc);
    // _pageController.jumpToPage(value);
  }

  Color _getNavBarColor() {
    switch (_selectedPageIndex) {
      case 0:
        return const Color(0xFF15D37A);
      case 1:
        return Colors.blue;
      case 2:
        return const Color(0xFFEB3A13);
    }
    return Colors.blue;
  }
}
