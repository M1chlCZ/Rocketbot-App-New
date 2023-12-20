import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' as intr;
import 'package:package_info_plus/package_info_plus.dart';
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
import 'package:rocketbot/providers/holdings_provider.dart';
import 'package:rocketbot/screens/main_screen.dart';
import 'package:rocketbot/screens/notification_screen.dart';
import 'package:rocketbot/storage/app_database.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/globals.dart' as globals;
import 'package:rocketbot/support/life_cycle_watcher.dart';
import 'package:rocketbot/support/route.dart';
import 'package:rocketbot/support/secure_storage.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/button_flat.dart';

import '../models/user.dart';
import '../widgets/coin_list_view.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({
    super.key,
  });

  @override
  PortfolioScreenState createState() => PortfolioScreenState();
}

class PortfolioScreenState extends LifecycleWatcherState<PortfolioScreen> with AutomaticKeepAliveClientMixin<PortfolioScreen> {
  final NetInterface _interface = NetInterface();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<ScrollDirection> scrollDirectionNotifier = ValueNotifier<ScrollDirection>(ScrollDirection.forward);
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
  double totalUSDYIELD = 0.0;
  double totalBTC = 0.0;
  double totalBTCYIELD = 0.0;

  bool portCalc = false;
  bool popMenu = false;
  bool _paused = false;
  bool _pinEnabled = false;
  bool _hideZero = false;

  List<String> messageIDs = [];

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
      var i = await SecureStorage.readStorage(key: globals.sortType);
      if (i == null) {
        _dropValue = _dropValues[0];
      } else {
        _dropValue = _dropValues[int.parse(i)];
      }
      setState(() {});
    });
  }

  Future<bool> _initPlatform() async {
    var di = await getDeviceInfo();
    if (di == false) {
      return false;
    }
    if (Platform.isAndroid) {
      try {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        var dots = tempPath.replaceAll(".", "");
        var numDots = tempPath.length - dots.length;
        var bundleOK = numDots < 3 ? true : false;
        var st = tempPath.split("/data/user");
        var projectAppID = await PackageInfo.fromPlatform().then((value) => value.packageName);
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

  Future<bool> getDeviceInfo() async {
    if (kDebugMode) return true;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        return true;
      } else {
        return false;
      }
    } else if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      bool andr = androidInfo.isPhysicalDevice;
      if (andr) {
        return true;
      } else {
        return false;
      }
    }
    return false;
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
      await _interface.get('status', pos: true);
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
      final response = await _interface.post("notification/list", {}, pos: true, debug: false);
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
        if (context.mounted) {
          Dialogs.openAlertBox(context, "Referral ${AppLocalizations.of(context)!.alert.toLowerCase()}", "Your reward is on the way|");
        }
      } catch (e) {
        if (context.mounted) Dialogs.openAlertBox(context, "Referral ${AppLocalizations.of(context)!.error.toLowerCase()}", e.toString());
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
    if (context.mounted) {
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

  @override
  Widget build(BuildContext context) {
    final m = ref.watch(holdingAmountProvider);
    super.build(context);
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: const Color(0xFFCB1668),
              onRefresh: _refreshData,
              child: NotificationListener<UserScrollNotification>(
                onNotification: (UserScrollNotification notification) {
                  if (notification.direction == ScrollDirection.forward || notification.direction == ScrollDirection.reverse) {
                    scrollDirectionNotifier.value = notification.direction;
                  }
                  return true;
                },
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
                              if (_me != null) Text("${_me!.data!.name} ${_me!.data!.surname}", style: Theme.of(context).textTheme.displaySmall),
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
                                              Navigator.of(context).push(pushRoute(const NotificationScreen())).then((value) => _getUnread());
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
                          child: Container(
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
                            child: m.when(
                              data: (data) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // alignment: AlignmentDirectional.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.balance,
                                            style: Theme.of(context).textTheme.displayMedium,
                                          ),
                                          const SizedBox(
                                            height: 7.0,
                                          ),
                                          AutoSizeText(
                                            "\$${intr.NumberFormat("#,##0.00", "en_US").format(data['totalUSD'])}",
                                            style: Theme.of(context).textTheme.displayLarge,
                                            minFontSize: 8.0,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(
                                            height: 7.0,
                                          ),
                                          AutoSizeText(
                                            "BTC ${_formatPrice(data['totalBTC']!)}",
                                            style: Theme.of(context).textTheme.displayMedium,
                                            minFontSize: 8.0,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // alignment: AlignmentDirectional.center,
                                        children: [
                                          Text(
                                            "PoS/MN",
                                            style: Theme.of(context).textTheme.displayMedium,
                                          ),
                                          const SizedBox(
                                            height: 7.0,
                                          ),
                                          AutoSizeText(
                                            "\$${intr.NumberFormat("#,##0.00", "en_US").format(data['totalUSDYIELD'])}",
                                            style: Theme.of(context).textTheme.displayLarge,
                                            minFontSize: 8.0,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(
                                            height: 7.0,
                                          ),
                                          AutoSizeText(
                                            "BTC ${_formatPrice(data['totalBTCYIELD']!)}",
                                            style: Theme.of(context).textTheme.displayMedium,
                                            minFontSize: 8.0,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              error: (error, st) => Center(
                                  child: Text(
                                error.toString(),
                                style: Theme.of(context).textTheme.titleMedium,
                              )),
                              loading: () => Center(
                                child: JumpingDotsProgressIndicator(
                                  numberOfDots: 3,
                                  color: Colors.white70,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          )),
                      if (!_emailOK)
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
                              child: const Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                  // Text('sort by:', style: Theme.of(context).textTheme.displayMedium!.copyWith( fontSize: 14.0, color: Colors.white30)),
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
                                        await SecureStorage.writeStorage(key: globals.sortType, value: sort.toString());
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
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium!
                                                            .copyWith(fontSize: 11.0, color: Colors.white70)),
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
                                              .displayMedium!
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
                                      _listCoins ??= snapshot.data!.data!;
                                      Future.delayed(Duration.zero, () {
                                        setState(() {
                                          portCalc = true;
                                        });
                                      });
                                    }
                                    return ListView.builder(
                                        cacheExtent: 0,
                                        addAutomaticKeepAlives: false,
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
                                          // return ValueListenableBuilder(
                                          //    valueListenable: scrollDirectionNotifier,
                                          //    child: CoinListView(
                                          //       key: ValueKey(snapshot.data!.data![index].coin!.id!),
                                          //       coin: snapshot.data!.data![index],
                                          //       free: Decimal.parse(snapshot.data!.data![index].free.toString()),
                                          //       coinSwitch: _changeCoin,
                                          //     ),
                                          //    builder: (context, ScrollDirection scrollDirection, child) {
                                          //      return AnimatedListItemWrapper(
                                          //        scrollDirection: scrollDirection,
                                          //        child: child!,
                                          //      );
                                          //    },
                                          //  );
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
                            //                   .displayLarge!
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
                            //               style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 14.0),
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
                            //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            //                     RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0), side: const BorderSide(color: Colors.transparent)))),
                            //             onPressed: () {
                            //               setState(() {
                            //                 popMenu = false;
                            //               });
                            //               Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                            //                 return const ReferralScreen();
                            //               }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                            //                 return FadeTransition(opacity: animation, child: child);
                            //               }));
                            //             },
                            //             child: Text(
                            //               AppLocalizations.of(context)!.referral.toUpperCase(),
                            //               style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 14.0),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     )),
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
                                        onPressed: () async {
                                          setState(() {
                                            popMenu = false;
                                          });
                                          String? s = await Utils.scanQR(context);
                                          processScan(s);
                                        },
                                        child: AutoSizeText(
                                          AppLocalizations.of(context)!.qr_scan.toUpperCase(),
                                          maxLines: 1,
                                          minFontSize: 4.0,
                                          style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 14.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
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
                                        onPressed: () async {
                                          setState(() {
                                            popMenu = false;
                                          });
                                          _loginWeb();

                                        },
                                        child: AutoSizeText(
                                          AppLocalizations.of(context)!.web_login.toUpperCase(),
                                          maxLines: 1,
                                          minFontSize: 4.0,
                                          style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 12.0),
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
                            //               style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 14.0),
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

  var ps = false;

  processScan(String? s) async {
    if (ps) return;
    ps = true;
    try {
      if (s != null) {
        if (s.contains('loginqr')) {
          var ss = s.split(";")[1];
          try {
            NetInterface interface = NetInterface();
            var tok = ss;
            await interface.post("/login/qr/auth", {"token": tok}, web: true, debug: false);
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login successful")));
          } catch (e) {
            debugPrint(e.toString());
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login failed")));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.qr_scan_error)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.qr_scan_error)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      ps = false;
    }
  }

  Future _refreshData() async {
    await _bloc!.fetchBalancesList(refresh: true);
    _listCoins = null;
    setState(() {});
  }

  _changeCoin(CoinBalance c) async {
    pl ??= await _getPosCoins();
    if (context.mounted) {
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
    var s = Decimal.parse(d.toString());
    var split = s.toString().split('.');
    if (split.length > 1) {
      var decimal = split[1];
      if (decimal.length >= 8) {
        var sub = decimal.substring(0, 7);
        return "${split[0]}.$sub";
      } else {
        return s.toString();
      }
    } else {
      return s.toString();
    }
  }

  // _calculatePortfolio() {
  //   try {
  //     totalUSD = 0;
  //     totalBTC = 0;
  //     totalUSDYIELD = 0;
  //     totalBTCYIELD = 0;
  //     for (var element in _listCoins!) {
  //       double? freeCoins = element.free ?? 0;
  //       double? freeMNCoins = element.posCoin?.amount ?? 0;
  //       double? priceUSD = element.priceData?.prices?.usd!.toDouble();
  //       double? priceBTC = element.priceData?.prices?.btc!.toDouble();
  //       if (priceUSD != null && priceBTC != null) {
  //         double usd = freeCoins * priceUSD;
  //         totalUSD += usd;
  //         double btc = freeCoins * priceBTC;
  //         totalBTC += btc;
  //         double usdMN = freeMNCoins * priceUSD;
  //         totalUSDYIELD += usdMN;
  //         double btcMN = freeMNCoins * priceBTC;
  //         totalBTCYIELD += btcMN;
  //       }
  //     }
  //
  //     Future.delayed(const Duration(milliseconds: 100), () {
  //       setState(() {
  //         portCalc = true;
  //       });
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     Future.delayed(const Duration(milliseconds: 200), () {
  //       setState(() {
  //         portCalc = true;
  //       });
  //     });
  //   }
  // }

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
      await SecureStorage.writeStorage(key: globals.countdown, value: endTime.toString());
      _paused = true;
    }
  }

  @override
  void onResumed() async {
    await _getPin();
    await _getNotifications();
    if (_pinEnabled == true && _paused) {
      _paused = false;
      RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null && initialMessage.data['link'] != null) {
        if (messageIDs.contains(initialMessage.messageId)) {
          return;
        } else {
          messageIDs.add(initialMessage.messageId ?? '');
          Utils.openLink(initialMessage.data["dataLink"]);
        }
      }
      var restart = await _checkCountdown();
      if (restart) {
        _restartApp();
      }
    }else if (_pinEnabled == false && _paused){
      _paused = false;
      RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null && initialMessage.data['link'] != null) {
        if (messageIDs.contains(initialMessage.messageId)) {
          return;
        } else {
          messageIDs.add(initialMessage.messageId ?? '');
          Utils.openLink(initialMessage.data["dataLink"]);
        }
      }
    }
  }

  Future<bool> _checkCountdown() async {
    var countDown = await SecureStorage.readStorage(key: globals.countdown);
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

  bool a = false;
  bool b= false;
  bool c = false;

  _loginWeb() async {
    if (a) return;
    a = true;
    var s = await Utils.getTwoFactorStatic();
    if (!s) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("2FA not enabled, please enable it in the settings")));
      }
      a = false;
      return;
    } else {
      if (context.mounted) Dialogs.open2FABoxNew(context, _check2FA);
    }
    a = false;
  }

  _check2FA(String? s) async {
    if (b) return;
    b = true;
    var aa = await Utils.check2FA(s ?? "");
    if (context.mounted) Navigator.of(context).pop();
    if (aa) {
      if (context.mounted) Dialogs.openWebTokenBox(context, _webToken);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login successful")));
    } else {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("2FA code is not valid")));
    }
    b = false;
  }

  _webToken(String webtoken) async {
    if (c) return;
    try {
      await _interface.post("/user/confirm", {"auth": webtoken}, web: true);
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Launchpad login successful")));
      c = false;
    } catch (e) {
      c = false;
      return null;
    }
  }
}
