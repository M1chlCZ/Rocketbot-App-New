import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/deposit_address.dart';
import 'package:rocketbot/models/pos_coins_list.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screenpages/coin_page.dart';
import 'package:rocketbot/screenpages/deposit_page.dart';
import 'package:rocketbot/screenpages/send_page.dart';
import 'package:rocketbot/widgets/button_flat.dart';

import '../screens/portfolio_page.dart';
import 'farm_main_screen.dart';

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
  bool isMN = false;
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
      isMN = widget.posCoinsList!.coinsMn!.contains(c?.id);
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
      final response = await _interface.post("Transfers/CreateDepositAddress", request, debug: true);
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
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return FarmMainScreen(
            changeFree: _changeFree,
            depositAddress: _depositAddr!,
            depositPosAddress: _posDepositAddr,
            activeCoin: _coinActive,
            coinBalance: _lc!.singleWhere((element) => element.coin!.id! == _coinActive.id!),
            free: _free,
            blockTouch: _blockTouch,
            masternode: isMN,
          );
        }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        }))
        .then((value) => _coinKey.currentState?.getFree());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
            physics: const NeverScrollableScrollPhysics(),
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
                  masternode: isMN,
                  setActiveCoin: _setActiveCoin,
                  changeFree: _changeFree,
                  activeCoin: _coinActive,
                  allCoins: _lc,
                  goBack: goBack,
                  goToStaking: _gotoStaking,
                  posDepositAddr: _posDepositAddr,
                  blockTouch: _blockTouch,
                  depositAddr: _depositAddr,
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
        elevation: 0.0,
        height: 60.0,
        onTap: _onTappedBar,
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape(
            centered: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.white,
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
        backgroundColor: const Color(0xff394359),
        unselectedItemColor: Colors.white30,
        snakeViewColor: _getNavBarColor(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FlatCustomButton(
                width: 40,
                height: 30,
                radius: 10.0,
                color: Colors.transparent,
                child: Image.asset(
                  "images/linear-recieve.png",
                  width: 30,
                  height: 30.0,
                  fit: BoxFit.fitWidth,
                  color: Colors.white,
                )),
            backgroundColor: Colors.amber,
            label: 'Receive',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(0);
              },
              child: Image.asset(
                "images/bold-recieve.png",
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
                child: Image.asset(
                  "images/linear-transaction.png",
                  width: 30,
                  height: 30.0,
                  fit: BoxFit.fitWidth,
                  color: Colors.white,
                )),
            label: 'Transactions',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(0);
              },
              child: Image.asset(
                "images/bold-transaction.png",
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
                child: Image.asset(
                  "images/linear-send.png",
                  width: 30,
                  height: 30.0,
                  fit: BoxFit.fitWidth,
                  color: Colors.white,
                )),
            label: 'Send',
            activeIcon: FlatCustomButton(
              width: 40,
              height: 30,
              radius: 10.0,
              color: Colors.transparent,
              onTap: () {
                _onTappedBar(0);
              },
              child: Image.asset(
                "images/bold-send.png",
                color: Colors.white,
                width: 30,
                height: 30.0,
                fit: BoxFit.fitHeight,
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

    // _pageController.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
    _pageController.jumpToPage(value);
  }

  Color _getNavBarColor() {
    return const Color(0xFF9D9BFD);
    // switch (_selectedPageIndex) {
    //   case 0:
    //     return const Color(0xFF15D37A);
    //   case 1:
    //     return Colors.blue;
    //   case 2:
    //     return const Color(0xFFEB3A13);
    // }
    // return Colors.blue;
  }
}
