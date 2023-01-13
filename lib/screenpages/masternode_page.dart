import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/bloc/masternode_graph_bloc.dart';
import 'package:rocketbot/models/balance_portfolio.dart';
import 'package:rocketbot/models/fees.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/models/masternode_data.dart';
import 'package:rocketbot/models/masternode_info.dart';
import 'package:rocketbot/models/masternode_lock.dart';
import 'package:rocketbot/models/pgwid.dart';
import 'package:rocketbot/models/withdraw_confirm.dart';
import 'package:rocketbot/models/withdraw_pwid.dart';
import 'package:rocketbot/netInterface/api_response.dart';
import 'package:rocketbot/netInterface/app_exception.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screens/keyboard_overlay.dart';
import 'package:rocketbot/screens/mn_manage_screen.dart';
import 'package:rocketbot/storage/app_database.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/gradient_text.dart';
import 'package:rocketbot/support/life_cycle_watcher.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/dropdown_menu_icon.dart';
import 'package:rocketbot/widgets/masternode_graph.dart';
import 'package:rocketbot/widgets/picture_cache.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../models/balance_list.dart';
import '../models/coin.dart';
import '../widgets/coin_price_graph.dart';
import '../widgets/time_stake_range_switch.dart';

class MasternodePage extends StatefulWidget {
  final Coin activeCoin;
  final CoinBalance coinBalance;
  final String? depositAddress;
  final Function(double free) changeFree;
  final Function(bool touch) blockTouch;
  final double free;
  final bool masternode;

  const MasternodePage({
    Key? key,
    required this.activeCoin,
    required this.coinBalance,
    required this.changeFree,
    this.depositAddress,
    required this.free,
    required this.blockTouch,
    required this.masternode,
  }) : super(key: key);

  @override
  MasternodePageState createState() => MasternodePageState();
}

class MasternodePageState extends LifecycleWatcherState<MasternodePage> {
  final NetInterface _interface = NetInterface();
  final _graphKey = GlobalKey<CoinPriceGraphState>();
  final GlobalKey<SlideActionState> _keyStake = GlobalKey();
  AppDatabase db = GetIt.I.get<AppDatabase>();
  FocusNode numberFocusNode = FocusNode();
  AnimationController? _animationController;
  Animation<double>? _animation;
  MasternodeGraphBloc? _mnBloc;
  MasternodeInfo? _mnInfo;
  late Coin _coinActive;
  var formatter = NumberFormat('#,###');

  bool _staking = false;
  bool _loadingReward = false;
  bool _loadingCoins = false;
  bool _paused = false;
  bool _detailsExtended = false;

  int _numberNodes = 0;
  int _dropdownValue = 0;
  int _freeMN = 0;
  int _pendingMasternodes = 0;
  String _amountReward = "0.0";
  double _estimated = 0.0;
  int _activeNodes = 0;
  String _averagePayrate = "00:00:00";
  String _averateTimeStart = "00:00:00";
  double _averagePayDay = 0.0;
  double _roi = 0.0;
  double _price = 0.0;
  double _free = 0.0;
  List<int> _collateralTiers = [];

  double? _fee;
  double? _min;
  int _typeGraph = 0;
  bool amountEmpty = true;
  int _collateral = 0;

  @override
  void initState() {
    super.initState();
    _price = widget.coinBalance.priceData!.prices!.usd!.toDouble();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController!, curve: Curves.fastLinearToSlowEaseIn));
    _coinActive = widget.activeCoin;
    _free = widget.free;
    _changeFree();
    _getMasternodeDetails();
    _mnBloc = MasternodeGraphBloc();
    _mnBloc!.stakeBloc();
    _getMN();
    _getFees();
    _getFocusIOS();
  }

  @override
  void dispose() {
    numberFocusNode.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _goToManagement() {
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return MasternodeManageScreen(
            mnInfo: _mnInfo!,
          );
        }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        }))
        .then((value) => _getMasternodeDetails());
  }

  void _getMN() {
    _mnBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
  }

  Future<void> _getMasternodeDetails() async {
    Map<String, dynamic> m = {
      "idCoin": _coinActive.id!,
      // "idCoin": 0
    };
    var res = await _interface.post("masternode/info", m, pos: true, debug: true);
    _mnInfo = MasternodeInfo.fromJson(res);
    if (_mnInfo == null || _mnInfo!.hasError == true) return;
    _numberNodes = _mnInfo?.mnList?.length ?? 0;
    _activeNodes = _mnInfo!.activeNodes!;
    double rev = _mnInfo!.nodeRewards!.fold(0, (previousValue, element) => previousValue + element.amount!);
    _amountReward = rev.toString();
    List<String> partsPayrate = _mnInfo!.averagePayTime!.split(".");
    _averagePayrate = partsPayrate[0].isEmpty ? "00:00:00" : partsPayrate[0];
    List<String> partsStart = _mnInfo!.averageTimeToStart!.split(".");
    _averateTimeStart = partsStart[0].isEmpty ? "00:00:00" : partsStart[0];
    _estimated = _mnInfo!.averageRewardPerDay!;
    _staking = _mnInfo!.mnList!.isNotEmpty ? true : false;
    _collateral = _mnInfo!.collateral!;
    _averagePayDay = _mnInfo!.averagePayDay!;
    _freeMN = _mnInfo?.freeList?.length ?? 0;
    _pendingMasternodes = _mnInfo?.pendingList?.length ?? 0;
    _collateralTiers = _mnInfo?.collateralTiers ?? [_collateral];
    _roi = _mnInfo?.roi ?? 0.0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: RefreshIndicator(
                onRefresh: () => _mnBloc!.fetchStakeData(_coinActive.id!, 0),
                child: StreamBuilder<ApiResponse<MasternodeData>>(
                    stream: _mnBloc!.coinsListStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.completed:
                            return CoinMasternodeGraph(
                              key: _graphKey,
                              rewards: snapshot.data?.data,
                              activeCoin: _coinActive,
                              type: _typeGraph,
                              blockTouch: _blockSwipe,
                            );
                          case Status.loading:
                            return Center(
                              child: HeartbeatProgressIndicator(
                                startScale: 0.01,
                                endScale: 0.4,
                                child: const Image(
                                  image: AssetImage('images/rocketbot_logo.png'),
                                  color: Colors.white30,
                                ),
                              ),
                            );
                          case Status.error:
                            return Container(
                              color: Colors.transparent,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.graph_no_data,
                                    style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.red),
                                  ),
                                ),
                              ),
                            );
                          default:
                            return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            SizedBox(
                height: 40,
                child: StakeTimeRangeSwitcher(
                  color: const Color(0xFFF68DB2),
                  key: const ValueKey<int>(1),
                  changeTime: _changeTime,
                )),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: double.infinity,
              height: 50.0,
              margin: const EdgeInsets.only(left: 15.0, right: 15.0),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PictureCacheWidget(
                      coin: widget.activeCoin,
                      size: 30.0,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      widget.activeCoin.cryptoId!,
                      // textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 5.0, left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.stake_available}:",
                          // textAlign: TextAlign.end,
                          style:
                              TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white.withOpacity(0.4)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: AutoSizeText(
                              "$_free",
                              maxLines: 1,
                              minFontSize: 8.0,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                            ),
                          ),
                        ),
                        Text(
                          _coinActive.ticker!,
                          // textAlign: TextAlign.end,
                          style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Color(0xFFF68DB2)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.mn_collateral}:",
                          // textAlign: TextAlign.end,
                          style:
                              TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white.withOpacity(0.4)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: AutoSizeText(
                              _collateralTiers.length > 1 ? "MULTIPLE" : _collateral.toString(),
                              maxLines: 1,
                              minFontSize: 8.0,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            _collateralTiers.length > 1 ? "TIERS" : _coinActive.ticker!,
                            // textAlign: TextAlign.end,
                            style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Color(0xFFF68DB2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.mn_your_mns}:",
                          // textAlign: TextAlign.end,
                          style:
                              TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white.withOpacity(0.4)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: AutoSizeText(
                              _numberNodes.toString(),
                              maxLines: 1,
                              minFontSize: 8.0,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                            ),
                          ),
                        ),
                        const Text(
                          "MNs",
                          // textAlign: TextAlign.end,
                          style: TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Color(0xFFF68DB2)),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_pendingMasternodes != 0)
                  Column(
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      Opacity(
                        opacity: 0.6,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.mn_uncofirmed}:",
                                  // textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white.withOpacity(0.4)),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: AutoSizeText(
                                      _pendingMasternodes.toString(),
                                      maxLines: 1,
                                      minFontSize: 8.0,
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                    ),
                                  ),
                                ),
                                Text(
                                  _pendingMasternodes == 1 ? "MN" : "MNs",
                                  // textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Color(0xFFF68DB2)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.mn_reward}:",
                          // textAlign: TextAlign.end,
                          style:
                              TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white.withOpacity(0.4)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: AutoSizeText(
                              _formatPriceString(_amountReward),
                              maxLines: 1,
                              minFontSize: 8.0,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                            ),
                          ),
                        ),
                        Text(
                          _coinActive.ticker!,
                          // textAlign: TextAlign.end,
                          style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Color(0xFFF68DB2)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
                  ),
                ),
                SizeTransition(
                  sizeFactor: _animation!,
                  child: Container(
                    color: Colors.black12,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child: Row(
                              children: [
                                GradientText(
                                  "${AppLocalizations.of(context)!.mn_total(_coinActive.ticker!)}:",
                                  gradient: const LinearGradient(colors: [
                                    Colors.white70,
                                    Colors.white54,
                                  ]),
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                    child: AutoSizeText(
                                      "$_activeNodes",
                                      maxLines: 1,
                                      minFontSize: 8.0,
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child: Row(
                              children: [
                                GradientText(
                                  "${AppLocalizations.of(context)!.mn_free}:",
                                  gradient: const LinearGradient(colors: [
                                    Colors.white70,
                                    Colors.white54,
                                  ]),
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                    child: AutoSizeText(
                                      _freeMN.toString(),
                                      maxLines: 1,
                                      minFontSize: 8.0,
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child: Row(
                              children: [
                                GradientText(
                                  "${AppLocalizations.of(context)!.mn_average_payrate}:",
                                  gradient: const LinearGradient(colors: [
                                    Colors.white70,
                                    Colors.white54,
                                  ]),
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                    child: AutoSizeText(
                                      _averagePayrate,
                                      maxLines: 1,
                                      minFontSize: 8.0,
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child: Row(
                              children: [
                                GradientText(
                                  "${AppLocalizations.of(context)!.mn_average_start}:",
                                  gradient: const LinearGradient(colors: [
                                    Colors.white70,
                                    Colors.white54,
                                  ]),
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                    child: AutoSizeText(
                                      _averateTimeStart.toString(),
                                      maxLines: 1,
                                      minFontSize: 8.0,
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!_staking)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Row(
                                children: [
                                  GradientText(
                                    "${AppLocalizations.of(context)!.mn_day_reward(_coinActive.ticker!)}:",
                                    gradient: const LinearGradient(colors: [
                                      Colors.white70,
                                      Colors.white54,
                                    ]),
                                    // textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                      child: AutoSizeText(
                                        "${_averagePayDay.toStringAsFixed(3)} ${_coinActive.ticker!}",
                                        maxLines: 1,
                                        minFontSize: 8.0,
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if(_staking)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child: Row(
                              children: [
                                GradientText(
                                  "${AppLocalizations.of(context)!.staking_est}:",
                                  gradient: const LinearGradient(colors: [
                                    Colors.white70,
                                    Colors.white54,
                                  ]),
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                    child: AutoSizeText(
                                      "${_estimated.toStringAsFixed(3)} ${_coinActive.ticker!}/${AppLocalizations.of(context)!.staking_day.toString().toUpperCase()}",
                                      maxLines: 1,
                                      minFontSize: 8.0,
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child: Row(
                              children: [
                                GradientText(
                                  "${AppLocalizations.of(context)!.mn_roi}:",
                                  gradient: const LinearGradient(colors: [
                                    Colors.white70,
                                    Colors.white54,
                                  ]),
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                    child: AutoSizeText(
                                      "${_roi.toStringAsFixed(2)}%",
                                      maxLines: 1,
                                      minFontSize: 8.0,
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_detailsExtended) {
                      _animationController!.reverse();
                      _detailsExtended = false;
                    } else {
                      _animationController!.forward();
                      _detailsExtended = true;
                    }
                    setState(() {});
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            _detailsExtended ? AppLocalizations.of(context)!.st_less : AppLocalizations.of(context)!.st_more,
                            // textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontFamily: 'JosefinSans', fontSize: 14.0, color: Colors.white70),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 15.0),
                  child: Column(
                    children: [
                      if (_collateralTiers.length > 1)
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: const Color(0xFFF68DB2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text("Masternode tier",
                                    style: TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white)),
                              ),
                              SizedBox(
                                width: 175,
                                child: DropDownIcon(
                                    onChange: (int value, int index) {
                                      setState(() {
                                        _collateral = value;
                                        _dropdownValue = index;
                                      });
                                    },
                                    dropdownButtonStyle: const DropdownButtonStyle(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      height: 40,
                                      elevation: 5,
                                      backgroundColor: Colors.transparent,
                                      primaryColor: Colors.white,
                                    ),
                                    dropdownStyle: DropdownStyle(
                                      borderRadius: BorderRadius.circular(5),
                                      elevation: 5,
                                      padding: const EdgeInsets.all(5),
                                      color: const Color(0xFFEC4681),
                                      offset: const Offset(5, 55),
                                    ),
                                    items: _collateralTiers
                                        .asMap()
                                        .entries
                                        .map(
                                          (item) => DropdownItem<int>(
                                            value: item.key + 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(
                                                "${formatter.format(item.value).replaceAll(",", " ")} ${_coinActive.ticker!}",
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16.0, color: Colors.white),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    currentIndex: _dropdownValue,
                                    child: const SizedBox.shrink()),
                              )
                            ],
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: const Color(0xFFF68DB2)),
                        child: Stack(
                          children: [
                            SlideAction(
                              height: 60.0,
                              sliderButtonIconPadding: 6.0,
                              borderRadius: 10.0,
                              text: AppLocalizations.of(context)!.mn_start,
                              innerColor: const Color(0xFFF68DB2),
                              outerColor: const Color(0xFF252F45),
                              elevation: 0.5,
                              // submittedIcon: const Icon(Icons.check, size: 30.0, color: Colors.lightGreenAccent,),
                              submittedIcon: const CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Color(0xFFF68DB2),
                              ),
                              sliderButtonIcon: const Icon(
                                Icons.arrow_forward,
                                color: Color(0xFF252F45),
                                size: 35.0,
                              ),
                              sliderRotate: false,
                              textStyle: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.white),
                              key: _keyStake,
                              onSubmit: () {
                                _createWithdrawal();
                              },
                            ),
                            if (_freeMN == 0)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60.0,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xFFBE235A)),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: AutoSizeText(
                                    "No ${widget.activeCoin.name} masternode available!",
                                    maxLines: 1,
                                    minFontSize: 8.0,
                                    style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white70),
                                  ),
                                )),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "${AppLocalizations.of(context)!.fees} $_fee ${_coinActive.ticker} \n ${AppLocalizations.of(context)!.mn_time_to_start}: $_averateTimeStart \n${AppLocalizations.of(context)!.mn_lock}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white30),
                  )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _staking
                    ? Column(
                        children: [
                          IgnorePointer(
                            ignoring: _amountReward == "0.0" ? true : false,
                            child: Opacity(
                              opacity: _amountReward == "0.0" ? 0.3 : 1.0,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: FlatCustomButton(
                                    onTap: () {
                                      if (!_loadingReward) {
                                        _unStake(1);
                                      }
                                    },
                                    radius: 10.0,
                                    color: const Color(0xFFF68DB2),
                                    child: SizedBox(
                                        height: 45.0,
                                        child: Center(
                                            child: _loadingReward
                                                ? const Padding(
                                                    padding: EdgeInsets.all(3.0),
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      color: Colors.white70,
                                                    ),
                                                  )
                                                : Text(
                                                    AppLocalizations.of(context)!.stake_get_reward,
                                                    style: const TextStyle(
                                                        fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 18.0, color: Colors.white),
                                                  ))),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          IgnorePointer(
                            ignoring: _staking == false ? true : false,
                            child: Opacity(
                              opacity: _staking == false ? 0.3 : 1.0,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: FlatCustomButton(
                                    onTap: () {
                                      if (!_loadingCoins) {
                                        _goToManagement();
                                        // _unStake(0);
                                      }
                                    },
                                    radius: 10.0,
                                    borderWidth: 2.0,
                                    borderColor: const Color(0xFFF68DB2),
                                    color: Theme.of(context).canvasColor,
                                    child: SizedBox(
                                        height: 45.0,
                                        child: Center(
                                            child: _loadingCoins
                                                ? const Padding(
                                                    padding: EdgeInsets.all(3.0),
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      color: Colors.white70,
                                                    ),
                                                  )
                                                : Text(
                                                    AppLocalizations.of(context)!.mn_manage,
                                                    style: const TextStyle(
                                                        fontFamily: 'JosefinSans',
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: 18.0,
                                                        color: Color(0xFFF68DB2)),
                                                  ))),
                                  )),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  _changeTime(int time) {
    _typeGraph = 0;
    _typeGraph = time;
    _mnBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
  }

  _blockSwipe(bool b) {
    widget.blockTouch(b);
  }

  String _formatPriceString(String d) {
    try {
      var split = d.toString().split('.');
      var decimal = split[1];
      if (decimal.length >= 3) {
        var sub = decimal.substring(0, 3);
        return ("${split[0]}.$sub").trim();
      } else {
        return d.toString().trim();
      }
    } catch (e) {
      return "0";
    }
  }

  _getFees() async {
    try {
      // _free = widget.free;
      final response = await _interface.get("Transfers/GetWithdrawFee?coinId=${widget.activeCoin.id!}");
      var d = Fees.fromJson(response);
      setState(() {
        _fee = d.data!.fee!;
        _min = d.data!.crypto!.minWithdraw!;
      });
    } catch (e) {
      setState(() {
        // _error = true;
      });
      debugPrint(e.toString());
    }
  }

  _createWithdrawal() async {
    Dialogs.openWaitBox(context);
    String serverTypeRckt = "<Rocketbot Service error>";
    String serverTypePos = "<Rocketbot POS Service error>";
    String problem = serverTypeRckt;
    WithdrawConfirm? rw;

    if (_mnInfo == null) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Data error");
      _keyStake.currentState?.reset();
      return;
    }

    var amt = _collateral;
    bool minAmount = amt < _min!;

    if (amt > _free) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.staking_not_enough);
      _keyStake.currentState?.reset();
      return;
    }

    if (widget.depositAddress == null || widget.depositAddress!.isEmpty) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Data err");
      _keyStake.currentState?.reset();
      return;
    }

    if (minAmount) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.staking_not_min(_min!.toString(), _coinActive.ticker!));
      _keyStake.currentState?.reset();
      return;
    }

    try {
      await _getMasternodeDetails();
    } catch (e) {
      debugPrint(e.toString());
    }
    MasternodeLock? mnLock;
    try {
      Map<String, dynamic> queryLock = {"idCoin": _coinActive.id!};
      final responseLock = await _interface.post("masternode/lock", queryLock, pos: true, debug: true);
      mnLock = MasternodeLock.fromJson(responseLock);
      if (mnLock.node?.address == null) {
        Navigator.of(context).pop();
        Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Data err");
        _keyStake.currentState?.reset();
        return;
      }

      Map<String, dynamic> query = {"coinId": _coinActive.id!, "fee": _fee, "amount": amt, "toAddress": mnLock.node!.address!};

      final response = await _interface.post("Transfers/CreateWithdraw", query, debug: true);
      var pwid = WithdrawID.fromJson(response);
      Map<String, dynamic> queryID = {
        "id": pwid.data!.pgwIdentifier!,
      };
      var resWith = await _interface.post("Transfers/ConfirmWithdraw", queryID);
      rw = WithdrawConfirm.fromJson(resWith);
      await db.addTX(rw.data!.pgwIdentifier!, _coinActive.id!, double.parse(_mnInfo!.collateral!.toString()), widget.depositAddress!,
          masternode: true);
      problem = serverTypePos;

      Map<String, dynamic> m = {
        "idCoin": _coinActive.id!,
        "depAddr": widget.depositAddress,
        "amount": _mnInfo!.collateral!,
        "pwd_id": rw.data!.pgwIdentifier!,
        "node_id": mnLock.node!.id!
      };
      await _interface.post("masternode/setup", m, pos: true, debug: true);
      _lostMNTX();
    } on ConflictDataException catch (e) {
      Map<String, dynamic> queryLock = {"idNode": mnLock?.node?.id};
      await _interface.post("masternode/unlock", queryLock, pos: true, debug: true);
      if (mounted) Navigator.of(context).pop();
      _keyStake.currentState?.reset();
      var err = json.decode(e.toString());
      if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, err['errorMessage']);
    } catch (e) {
      Map<String, dynamic> queryLock = {"idNode": mnLock?.node?.id};
      await _interface.post("masternode/unlock", queryLock, pos: true, debug: true);
      if (mounted) Navigator.of(context).pop();
      _keyStake.currentState?.reset();
      if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, e.toString());
    }

    if (rw == null) {
      _keyStake.currentState?.reset();
      if (mounted) Navigator.of(context).pop();
      if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Couldn't send coins for Staking \n\n$serverTypeRckt");
    }
    _changeFree();
    _keyStake.currentState?.reset();
    await _getMasternodeDetails();
    _mnBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
    setState(() {});
    if (mounted) Navigator.of(context).pop();
  }

  _lostMNTX() async {
    List<PGWIdentifier> l = await db.getUnfinishedTXMN();
    for (var element in l) {
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
          debugPrint("masternode/confirm/////");
          await _interface.post("masternode/confirm", m, pos: true);
          await db.finishTX(pgwid!);
          await Future.delayed(const Duration(seconds: 3));
          _getMN();
          _getMasternodeDetails();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  _unStake(int rewardParam) async {
    if (_loadingReward || _loadingCoins) {
      return;
    }
    Dialogs.openWaitBox(context);
    if (rewardParam == 1) {
      _loadingReward = true;
    } else {
      _loadingCoins = true;
    }
    setState(() {});
    try {
      if (rewardParam == 1) {
        Map<String, dynamic> m = {"idCoin": _coinActive.id!};
        await _interface.post("masternode/reward", m, pos: true);
      }
      _changeFree();

      _mnBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
      var conf = _coinActive.requiredConfirmations;
      if (rewardParam == 1) {
        _loadingReward = false;
      } else {
        _loadingCoins = false;
      }
      await _getMasternodeDetails();
      _getMN();
      setState(() {});
      if (mounted) {
        Navigator.of(context).pop();
        await Dialogs.openAlertBox(
            context, AppLocalizations.of(context)!.alert, AppLocalizations.of(context)!.staking_with_info(conf.toString()));
        await _getMasternodeDetails();
        _getMN();
      }
    } on ConflictDataException catch (e) {
      var err = json.decode(e.toString());
      if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, err['errorMessage'].toString());
    } catch (e) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, e.toString());
    }
  }

  void _changeFree() async {
    var preFree = 0.0;
    var resB = await _interface.get("User/GetBalance?coinId=${_coinActive.id!}");
    var rs = BalancePortfolio.fromJson(resB);
    preFree = rs.data!.free!;
    _free = preFree;
    widget.changeFree(preFree);
    setState(() {});
  }

  @override
  void onDetached() {
    if (!_paused) {
      _paused = true;
    }
  }

  @override
  void onInactive() {
    if (!_paused) {
      _paused = true;
    }
  }

  @override
  void onPaused() {
    if (!_paused) {
      _paused = true;
    }
  }

  @override
  void onResumed() {
    if (_paused) {
      _getMN();
      _paused = false;
    }
  }

  void _getFocusIOS() {
    if (Platform.isIOS) {
      numberFocusNode.addListener(() {
        bool hasFocus = numberFocusNode.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      });
    }
  }
}
