import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get_it/get_it.dart';
import 'package:get_version/get_version.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/bloc/balance_bloc.dart';
import 'package:rocketbot/cache/price_graph_cache.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/deposit_address.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/models/notifications.dart';
import 'package:rocketbot/models/pgwid.dart';
import 'package:rocketbot/models/pos_coins_list.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screens/main_screen.dart';
import 'package:rocketbot/screens/notification_screen.dart';
import 'package:rocketbot/screens/referral_screen.dart';
import 'package:rocketbot/storage/app_database.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/globals.dart' as globals;
import 'package:rocketbot/support/life_cycle_watcher.dart';
import 'package:rocketbot/support/secure_storage.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../models/user.dart';
import '../widgets/coin_list_view.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({
    Key? key,
  }) : super(key: key);

  @override
  PortfolioScreenState createState() => PortfolioScreenState();
}

class PortfolioScreenState extends LifecycleWatcherState<PortfolioScreen> with AutomaticKeepAliveClientMixin<PortfolioScreen> {
  final NetInterface _interface = NetInterface();
  final ScrollController _scrollController = ScrollController();
  BalancesBloc? _bloc;
  PosCoinsList? pl;
  List<CoinBalance>? _listCoins;
  final List<int> _socials = [];
  AppDatabase db = GetIt.I.get<AppDatabase>();
  User? _me;
  int _unreadNot = 0;
  bool auth = false;

  bool _socialsOK = true;
  bool _emailOK = false;

  double totalUSD = 0.0;
  double totalBTC = 0.0;

  bool portCalc = false;
  bool popMenu = false;
  bool _paused = false;
  bool _pinEnabled = false;
  bool _hideZero = false;

  var _dropValue = "Default";
  var _dropValues = ["Default", "By amount", "Alphabetically"];

  @override
  void initState() {
    _authPing();
    _bloc = BalancesBloc();
    super.initState();
    _scrollController.addListener(() {
      if (popMenu) {
        setState(() {
          popMenu = false;
        });
      }
    });
    _fillSort();
    _getUserInfo();
    _posHandle();
    _codesUpload();
    _getNotifications();
  }

  void _fillSort() {
    Future.delayed(Duration.zero, () async {
      _dropValue = AppLocalizations.of(context)!.deflt;
      _dropValues.clear();
      _dropValues = [
        AppLocalizations.of(context)!.deflt,
        AppLocalizations.of(context)!.alphabeticall,
        AppLocalizations.of(context)!.by_amount,
        AppLocalizations.of(context)!.by_value
      ];
      var i = await SecureStorage.readStorage(key: globals.SORT_TYPE);
      if (i == null) {
        _dropValue = _dropValues[0];
      } else {
        _dropValue = _dropValues[int.parse(i)];
      }
      setState(() {});
    });
  }

  Future<bool> _initPlatform() async {
    if (Platform.isAndroid) {
      try {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        var dots = tempPath.replaceAll(".", "");
        var numDots = tempPath.length - dots.length;
        var bundleOK = numDots < 3 ? true : false;
        var st = tempPath.split("/data/user");
        var projectAppID = await GetVersion.appID;
        if (projectAppID == "com.m1chl.rocketbot" && st.length == 2 && bundleOK && !tempPath.contains("virtual")) {
          return true;
        } else {
          return false;
        }
      } on PlatformException {
        return false;
      }
    } else {
      return true;
    }
  }

  _getUserInfo() async {
    auth = await _initPlatform();
    try {
      final response = await _interface.get("User/Me");
      var d = User.fromJson(response);
      if (d.hasError == false) {
        _me = d;
        for (var element in d.data!.socialMediaAccounts!) {
          _socials.add(element.socialMedia!);
        }
        if (_socials.isNotEmpty) {
          setState(() {
            _socialsOK = true;
          });
        } else {
          setState(() {
            _socialsOK = false;
          });
        }
        if (d.data!.emailConfirmed != null && d.data!.emailConfirmed!) {
          setState(() {
            _emailOK = true;
          });
        } else {
          setState(() {
            _emailOK = false;
          });
        }
      } else {
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _authPing() async {
    try {
      await _interface.get('auth/ping', pos: true);
      debugPrint('ok');
    } catch (e) {
      debugPrint('register');
      try {
        await NetInterface.registerPosHandle();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  _codesUpload() async {
    try {
      String udid = await FlutterUdid.consistentUdid;
      String? firebase = await SecureStorage.readStorage(key: 'firebase_token');
      String? depAddr = await _getMergeDepositAddr();
      if (depAddr != null) {
        var m = {"uuid": udid, "firebase": firebase, "mergeDeposit": depAddr};
        await _interface.post('auth/codes', m, pos: true);
        String? rewardCode = await SecureStorage.readStorage(key: 'r_code');
        if (rewardCode != null && rewardCode.isNotEmpty) {
          _getReward(rewardCode);
        }
      } else {
        debugPrint("CODES NULL");
        _reUploadCodes();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _reUploadCodes() {
    Future.delayed(const Duration(seconds: 5), () async {
      await _codesUpload();
      String? rewardCode = await SecureStorage.readStorage(key: 'r_code');
      if (rewardCode != null && rewardCode.isNotEmpty) {
        _getReward(rewardCode);
      }
    });
  }

  Future<String?> _getMergeDepositAddr() async {
    String? s = await SecureStorage.readStorage(key: 'merge_addr');
    if (s == null || s.isEmpty) {
      Map<String, dynamic> request = {
        "coinId": 2,
      };
      try {
        final response = await _interface.post("Transfers/CreateDepositAddress", request);
        var d = DepositAddress.fromJson(response);
        await SecureStorage.writeStorage(key: 'merge_addr', value: d.data!.address!);
        return d.data!.address!;
      } catch (e) {
        // Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Can't get Merge deposit address, please verify your account!");
        return null;
      }
    } else {
      return s;
    }
  }

  Future<void> _getNotifications() async {
    try {
      final response = await _interface.post("notification/list", {}, pos: true);
      Notifications not = Notifications.fromJson(response);
      await db.addNot(not);
      var i = await db.getNotUnread();
      if (i == 0) {
        return;
      }
      setState(() {
        _unreadNot = i;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _getUnread() async {
    setState(() {
      _unreadNot = 0;
    });
  }

  Future<void> _getReward(String? code) async {
    String udid = await FlutterUdid.consistentUdid;
    if (code != null) {
      try {
        await _interface.post('code/submit', {"referral": code, "uuid": udid, "ver": 3}, pos: true);
        await SecureStorage.writeStorage(key: "refCode", value: code);
        if (mounted) Dialogs.openAlertBox(context, "Referral ${AppLocalizations.of(context)!.alert.toLowerCase()}", "Your reward is on the way|");
      } catch (e) {
        if (mounted) Dialogs.openAlertBox(context, "Referral ${AppLocalizations.of(context)!.error.toLowerCase()}", e.toString());
      }
      await SecureStorage.deleteStorage(key: 'r_code');
    }
  }

  @override
  void dispose() {
    _bloc!.dispose();
    super.dispose();
  }

  Matrix4 scaleXYZTransform({
    double scaleX = 1.05,
    double scaleY = 1.00,
    double scaleZ = 0.00,
  }) {
    return Matrix4.diagonal3Values(scaleX, scaleY, scaleZ);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<CoinBalance> getList() {
    return _listCoins!;
  }

  _posHandle() async {
    await _lostPosTX();
  }

  _lostPosTX() async {
    List<PGWIdentifier> l = await db.getUnfinishedTXPos();
    for (var element in l) {
      var coindID = element.getCoinID();
      var pgwid = element.getPGW();

      if (element.getStatus() == 0) {
        String? txid;
        await Future.doWhile(() async {
          try {
            await Future.delayed(const Duration(seconds: 3));
            final withdrawals = await _interface.get("Transfers/GetWithdraws?page=1&pageSize=10&coinId=$coindID");
            List<DataWithdrawals>? withRld = WithdrawalsModels.fromJson(withdrawals).data;
            for (var el in withRld!) {
              if (el.pgwIdentifier! == pgwid) {
                if (el.transactionId != null) {
                  txid = el.transactionId;
                  return false;
                }
              }
            }
          } catch (e) {
            return true;
          }
          return true;
        });

        try {
          Map<String, dynamic> m = {
            "pwd_id": pgwid,
            "tx_id": txid,
          };
          await _interface.post("stake/confirm", m, pos: true);
          await db.finishTX(pgwid!);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }

    List<PGWIdentifier> ll = await db.getUnfinishedTXMN();
    for (var element in ll) {
      var coindID = element.getCoinID();
      var pgwid = element.getPGW();
      if (element.getStatus() == 0) {
        String? txid;
        await Future.doWhile(() async {
          try {
            await Future.delayed(const Duration(seconds: 3));
            final withdrawals = await _interface.get("Transfers/GetWithdraws?page=1&pageSize=10&coinId=$coindID");
            List<DataWithdrawals>? withrld = WithdrawalsModels.fromJson(withdrawals).data;
            for (var el in withrld!) {
              if (el.pgwIdentifier! == pgwid) {
                if (el.transactionId != null) {
                  txid = el.transactionId;
                  return false;
                }
              }
            }
          } catch (e) {
            return true;
          }
          return true;
        });

        try {
          Map<String, dynamic> m = {
            "pwd_id": pgwid,
            "tx_id": txid,
          };
          await _interface.post("masternode/confirm", m, pos: true);
          await db.finishTX(pgwid!);
          await Future.delayed(const Duration(seconds: 3));
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  Future<void> connectWallet() async {
    // Create a connector
    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: ['https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'],
      ),
    );

// Subscribe to events
    connector.on('connect', (session) => print(session));
    connector.on('session_update', (payload) => print(payload));
    connector.on('disconnect', (session) => print(session));

// Create a new session
    if (!connector.connected) {
      final session = await connector.createSession(
        chainId: 1,
        onDisplayUri: (uri) => Utils.openLink(uri),
      );
      var s = await connector.approveSession(chainId: 1, accounts: ['0x4292...931B3']);
      print(s);
    }
    connector.killSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: const Color(0xFFCB1668),
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 0.0),
                      child: AnimatedOpacity(
                        opacity: _me != null ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Row(
                          children: [
                            if (_me != null) Text("${_me!.data!.name} ${_me!.data!.surname}", style: Theme.of(context).textTheme.headline3),
                            const SizedBox(
                              width: 50,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: auth,
                                        child: SizedBox(
                                          height: 30,
                                          width: 25,
                                          child: NeuButton(
                                            onTap: () async {
                                              setState(() {
                                                if (popMenu) {
                                                  popMenu = false;
                                                } else {
                                                  popMenu = true;
                                                }
                                              });
                                            },
                                            imageIcon: Image.asset(
                                              "images/candle.png",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width: 25,
                                        child: NeuButton(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                                                  return const NotificationScreen();
                                                }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                                  return FadeTransition(opacity: animation, child: child);
                                                }))
                                                .then((value) => _getUnread());
                                          },
                                          imageIcon: Image.asset(
                                            _unreadNot > 0 ? "images/notification_on.png" : "images/notification_off.png",
                                            color: _unreadNot > 0 ? Colors.amber : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 115,
                      child: portCalc
                          ? Container(
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: const DecorationImage(
                                    opacity: 0.5,
                                    scale: 0.5,
                                    filterQuality: FilterQuality.high,
                                    alignment: Alignment(0.0, 1.0),
                                    fit: BoxFit.cover,
                                    image: AssetImage("images/bal.png")),
                                gradient: const RadialGradient(center: Alignment(1.5, -3.0), radius: 5.0, colors: [
                                  Color(0xFF7388FF),
                                  Color(0xFFCA73FF),
                                  Color(0xFFFF739D),
                                ]),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // alignment: AlignmentDirectional.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.balance,
                                        style: Theme.of(context).textTheme.headline2,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 18.0,
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          "\$${totalUSD.toStringAsFixed(2)}",
                                          style: Theme.of(context).textTheme.headline1,
                                          minFontSize: 8.0,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3.0,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 3.0),
                                          child: AutoSizeText(
                                            "${_formatPrice(totalBTC)} BTC",
                                            style: Theme.of(context).textTheme.headline2,
                                            minFontSize: 8.0,
                                            maxLines: 1,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    if(!_emailOK)
                    GestureDetector(
                      onTap: () {
                        Utils.openLink("https://app.rocketbot.pro/Account/General");
                      },
                      child: Container(
                          height: 30,
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 3.0),
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                Color(0xFFF05523),
                                Color(0xFF812D88),
                              ]),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:const [
                               Text(
                                "Please confirm your email",
                                style: TextStyle(fontSize: 12.0, color: Colors.white),
                              ),
                               SizedBox(
                                width: 5.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1.0),
                                child: Icon(
                                  Icons.open_in_new,
                                  color: Colors.white,
                                  size: 12.0,
                                ),
                              ),
                            ],
                          ))),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    SizedBox(
                      height: 25.0,
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 3.0),
                          child: Opacity(
                            opacity: 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 0.0),
                                  child: Icon(
                                    Icons.sort,
                                    color: Colors.white30,
                                    size: 10.0,
                                  ),
                                ),
                                // Text('sort by:', style: Theme.of(context).textTheme.headline2!.copyWith( fontSize: 14.0, color: Colors.white30)),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _dropValue,
                                    isDense: true,
                                    onChanged: (String? val) async {
                                      _bloc!.showWait();
                                      setState(() {
                                        _dropValue = val!;
                                        _listCoins = null;
                                      });
                                      await Future.delayed(const Duration(milliseconds: 100), () {});
                                      int sort = _dropValues.indexWhere((element) => element == _dropValue);
                                      await SecureStorage.writeStorage(key: globals.SORT_TYPE, value: sort.toString());
                                      await _bloc!.fetchBalancesList(sort: sort);
                                      await _checkZero();
                                    },
                                    items: _dropValues
                                        .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: SizedBox(
                                                width: 130,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 2.0),
                                                  child: Text(e,
                                                      style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 11.0, color: Colors.white70)),
                                                ))))
                                        .toList(),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0, right: 8.0, top: 1.0),
                                    child: SizedBox(
                                      height: 0.5,
                                      child: Container(
                                        color: portCalc ? Colors.white12 : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1.0),
                                  child: FlatCustomButton(
                                    onTap: () async {
                                      _bloc!.showWait();
                                      await Future.delayed(const Duration(milliseconds: 100), () {});
                                      setState(() {
                                        _listCoins = null;
                                        if (_hideZero) {
                                          _hideZero = false;
                                          _bloc!.fetchBalancesList();
                                          // _bloc!.filterCoinsList(zero: _hideZero);
                                        } else {
                                          _hideZero = true;
                                          _bloc!.filterCoinsList(zero: _hideZero);
                                          // _bloc!.filterCoinsList(zero: _hideZero);
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0, right: 1.0),
                                      child: FittedBox(
                                          child: AutoSizeText(
                                        AppLocalizations.of(context)!.hide_zeros,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(fontSize: 11.0, color: _hideZero ? Colors.white : Colors.white30),
                                      )),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 5.0, right: 5.0),
                        child: StreamBuilder<ApiResponse<List<CoinBalance>>>(
                          stream: _bloc!.coinsListStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data!.status) {
                                case Status.loading:
                                  _listCoins = null;
                                  return Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 40.0),
                                      child: HeartbeatProgressIndicator(
                                        startScale: 0.01,
                                        endScale: 0.2,
                                        child: const Image(
                                          image: AssetImage('images/rocketbot_logo.png'),
                                          color: Colors.white30,
                                        ),
                                      ),
                                    ),
                                  );
                                case Status.completed:
                                  PriceGraphCache.refreshAllRecords();
                                  if (_listCoins == null) {
                                    _listCoins = snapshot.data!.data!;
                                    _calculatePortfolio();
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      itemCount: snapshot.data!.data!.length,
                                      itemBuilder: (ctx, index) {
                                        return CoinListView(
                                          key: ValueKey(snapshot.data!.data![index].coin!.id!),
                                          coin: snapshot.data!.data![index],
                                          free: Decimal.parse(snapshot.data!.data![index].free.toString()),
                                          coinSwitch: _changeCoin,
                                        );
                                      });
                                case Status.error:
                                  debugPrint("error");
                                  break;
                              }
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ),
            Visibility(
                visible: false,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        popMenu = false;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 50.0),
                      color: Colors.transparent,
                      width: double.infinity,
                      height: double.infinity,
                    ))),
            Positioned(
              top: 40.0,
              right: 4.0,
              child: IgnorePointer(
                ignoring: popMenu ? false : true,
                child: AnimatedOpacity(
                  opacity: popMenu ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                  child: Card(
                    elevation: 10.0,
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      child: Container(
                        width: 120,
                        color: Theme.of(context).canvasColor,
                        child: Column(
                          children: [
                            // SizedBox(
                            //     // SizedBox(
                            //     height: 40,
                            //     child: Center(
                            //       child: Directionality(
                            //         textDirection: TextDirection.ltr,
                            //         child: SizedBox(
                            //           width: 140,
                            //           child: TextButton(
                            //             style: ButtonStyle(
                            //                 backgroundColor: MaterialStateProperty.resolveWith((states) => qrColors(states)),
                            //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.circular(0.0), side: const BorderSide(color: Colors.transparent)))),
                            //             onPressed: () {
                            //               setState(() {
                            //                 popMenu = false;
                            //               });
                            //               Navigator.of(context)
                            //                   .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                            //                     return SocialScreen(
                            //                       socials: _socials,
                            //                       me: _me!,
                            //                     );
                            //                   }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                            //                     return FadeTransition(opacity: animation, child: child);
                            //                   }))
                            //                   .then((value) => _getUserInfo());
                            //             },
                            //             child: Text(
                            //               AppLocalizations.of(context)!.socials_popup + (_socialsOK ? '' : ' (!)'),
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .headline1!
                            //                   .copyWith(fontSize: 14.0, color: _socialsOK ? Colors.white : Colors.red),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     )),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            //   child: Container(
                            //     height: 0.5,
                            //     color: Colors.white12,
                            //   ),
                            // ),
                            // SizedBox(
                            //     // SizedBox(
                            //     height: 40,
                            //     child: Center(
                            //       child: Directionality(
                            //         textDirection: TextDirection.ltr,
                            //         child: SizedBox(
                            //           width: 140,
                            //           child: TextButton(
                            //             style: ButtonStyle(
                            //                 backgroundColor: MaterialStateProperty.resolveWith((states) => qrColors(states)),
                            //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.circular(0.0), side: const BorderSide(color: Colors.transparent)))),
                            //             onPressed: () {
                            //               setState(() {
                            //                 popMenu = false;
                            //               });
                            //               // Navigator.of(context)
                            //               //     .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                            //               //       return const SettingsScreen();
                            //               //     }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                            //               //       return FadeTransition(opacity: animation, child: child);
                            //               //     }))
                            //               //     .then((value) => _fillSort());
                            //             },
                            //             child: Text(
                            //               AppLocalizations.of(context)!.settings_popup,
                            //               style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.0),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     )),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            //   child: Container(
                            //     height: 0.5,
                            //     color: Colors.white12,
                            //   ),
                            // ),
                            SizedBox(
                                // SizedBox(
                                height: 40,
                                child: Center(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: SizedBox(
                                      width: 140,
                                      child: TextButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith((states) => qrColors(states)),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0), side: const BorderSide(color: Colors.transparent)))),
                                        onPressed: () {
                                          setState(() {
                                            popMenu = false;
                                          });
                                          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                                            return const ReferralScreen();
                                          }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                            return FadeTransition(opacity: animation, child: child);
                                          }));
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.referral.toUpperCase(),
                                          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            //   child: Container(
                            //     height: 0.5,
                            //     color: Colors.white12,
                            //   ),
                            // ),
                            // SizedBox(
                            //     // SizedBox(
                            //     height: 40,
                            //     child: Center(
                            //       child: Directionality(
                            //         textDirection: TextDirection.ltr,
                            //         child: SizedBox(
                            //           width: 140,
                            //           child: TextButton(
                            //             style: ButtonStyle(
                            //                 backgroundColor: MaterialStateProperty.resolveWith((states) => qrColors(states)),
                            //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.circular(0.0), side: const BorderSide(color: Colors.transparent)))),
                            //             onPressed: () {
                            //               setState(() {
                            //                 popMenu = false;
                            //               });
                            //               Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                            //                 return const AboutScreen();
                            //               }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                            //                 return FadeTransition(opacity: animation, child: child);
                            //               }));
                            //             },
                            //             child: Text(
                            //               AppLocalizations.of(context)!.about_popup,
                            //               style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.0),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !portCalc,
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                color: Theme.of(context).canvasColor,
                child: Center(
                  child: HeartbeatProgressIndicator(
                    startScale: 0.01,
                    endScale: 0.2,
                    child: const Image(
                      image: AssetImage('images/rocketbot_logo.png'),
                      color: Colors.white30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _refreshData() async {
    await _bloc!.fetchBalancesList(refresh: true);
    _listCoins = null;
    setState(() {});
  }

  _changeCoin(CoinBalance c) async {
    pl ??= await _getPosCoins();
    if (mounted) {
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return MainScreen(
              posCoinsList: pl,
              refreshList: _refreshData,
              coinBalance: c,
              listCoins: _listCoins,
            );
          }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }))
          .then((value) => _lostPosTX());
    }
  }

  Future<PosCoinsList?> _getPosCoins() async {
    try {
      var response = await _interface.get("coin/get", pos: true);
      return PosCoinsList.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  String _formatPrice(double d) {
    var split = d.toString().split('.');
    var decimal = split[1];
    if (decimal.length >= 8) {
      var sub = decimal.substring(0, 7);
      return "${split[0]}.$sub";
    } else {
      return d.toString();
    }
  }

  _calculatePortfolio() {
    try {
      totalUSD = 0;
      totalBTC = 0;
      for (var element in _listCoins!) {
        double? freeCoins = element.free;
        double? priceUSD = element.priceData?.prices?.usd!.toDouble();
        double? priceBTC = element.priceData?.prices?.btc!.toDouble();
        if (priceUSD != null && priceBTC != null) {
          double usd = freeCoins! * priceUSD;
          totalUSD += usd;
          double btc = freeCoins * priceBTC;
          totalBTC += btc;
        }
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          portCalc = true;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          portCalc = true;
        });
      });
    }
  }

  Color qrColors(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white30;
    }
    return const Color(0xFF1E273A);
  }

  Future _getPinFuture() async {
    var s = SecureStorage.readStorage(key: "PIN");
    return s;
  }

  Future<void> _getPin() async {
    final String? pin = await _getPinFuture();
    if (pin != null) _pinEnabled = true;
  }

  void _restartApp() async {
    Phoenix.rebirth(context);
  }

  @override
  void onDetached() {
    _paused = true;
  }

  @override
  void onInactive() {}

  @override
  void onPaused() async {
    if (!_paused) {
      var endTime = DateTime.now().millisecondsSinceEpoch + (1000 * 60);
      await SecureStorage.writeStorage(key: globals.COUNTDOWN, value: endTime.toString());
      _paused = true;
    }
  }

  @override
  void onResumed() async {
    await _getPin();
    await _getNotifications();
    if (_pinEnabled == true && _paused) {
      _paused = false;
      var restart = await _checkCountdown();
      if (restart) {
        _restartApp();
      }
    }
  }

  Future<bool> _checkCountdown() async {
    var countDown = await SecureStorage.readStorage(key: globals.COUNTDOWN);
    if (countDown != null) {
      int nowDate = DateTime.now().millisecondsSinceEpoch;
      int countTime = int.parse(countDown);
      if (nowDate > countTime) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  _checkZero() async {
    if (_hideZero == false) return;
    Future.delayed(Duration.zero, () {
      _bloc!.filterCoinsList(zero: _hideZero);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
