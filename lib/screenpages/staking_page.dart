import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/bloc/stake_graph_bloc.dart';
import 'package:rocketbot/models/balance_portfolio.dart';
import 'package:rocketbot/models/fees.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/models/pgwid.dart';
import 'package:rocketbot/models/stake_check.dart';
import 'package:rocketbot/models/stake_data.dart';
import 'package:rocketbot/models/withdraw_confirm.dart';
import 'package:rocketbot/models/withdraw_pwid.dart';
import 'package:rocketbot/netInterface/api_response.dart';
import 'package:rocketbot/netInterface/app_exception.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screens/keyboard_overlay.dart';
import 'package:rocketbot/storage/app_database.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/gradient_text.dart';
import 'package:rocketbot/support/life_cycle_watcher.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/percent_switch_widget.dart';
import 'package:rocketbot/widgets/picture_cache.dart';
import 'package:rocketbot/widgets/stake_graph.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../models/balance_list.dart';
import '../models/coin.dart';
import '../support/auto_size_text_field.dart';
import '../widgets/coin_price_graph.dart';
import '../widgets/time_stake_range_switch.dart';

class StakingPage extends StatefulWidget {
  final Coin activeCoin;
  final CoinBalance coinBalance;
  final String? depositAddress;
  final String? depositPosAddress;
  final Function(double free) changeFree;
  final Function(bool touch) blockTouch;
  final double free;

  const StakingPage({
    Key? key,
    required this.activeCoin,
    required this.coinBalance,
    required this.changeFree,
    this.depositAddress,
    this.depositPosAddress,
    required this.free,
    required this.blockTouch,
  }) : super(key: key);

  @override
  StakingPageState createState() => StakingPageState();
}

class StakingPageState extends LifecycleWatcherState<StakingPage> {
  // final _storage = const FlutterSecureStorage();
  final NetInterface _interface = NetInterface();
  final _graphKey = GlobalKey<CoinPriceGraphState>();
  final _percentageKey = GlobalKey<PercentSwitchWidgetState>();
  final GlobalKey<SlideActionState> _keyStake = GlobalKey();
  final TextEditingController _amountController = TextEditingController();
  AppDatabase db = GetIt.I.get<AppDatabase>();
  FocusNode numberFocusNode = FocusNode();
  AnimationController? _animationController;
  Animation<double>? _animation;
  StakeGraphBloc? _stakeBloc;
  late Coin _coinActive;

  bool _staking = false;
  bool _loadingReward = false;
  bool _loadingCoins = false;
  bool _adjustReward = false;
  bool _paused = false;
  bool _detailsExtended = false;

  String _amountStaked = "0.0";
  double _unconfirmedAmount = 0.0;
  String _amountReward = "0.0";
  double _estimated = 0.0;
  double _percentage = 0.0;
  double _inPoolTotal = 0.0;
  double _price = 0.0;
  double _free = 0.0;

  double? _fee;
  double? _min;
  int _typeGraph = 0;
  bool amountEmpty = true;

  @override
  void initState() {
    super.initState();
    _price = widget.coinBalance.priceData?.prices?.usd?.toDouble() ?? 0.0;
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController!, curve: Curves.fastLinearToSlowEaseIn));
    _coinActive = widget.activeCoin;
    _free = widget.free;
    _changeFree();
    _amountController.addListener(() {
      if (_amountController.text.isEmpty) {
        setState(() {
          amountEmpty = true;
        });
      } else {
        setState(() {
          amountEmpty = false;
        });
      }
      _percentageKey.currentState!.deActivate();
    });
    _stakeBloc = StakeGraphBloc();
    _stakeBloc!.stakeBloc();
    _getPos();
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

  void _getPos() {
    _stakeBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
    _getStakingDetails();
  }

  Future<void> _getStakingDetails() async {
    Map<String, dynamic> m = {
      "idCoin": _coinActive.id!,
      // "idCoin": 0
    };
    var res = await _interface.post("stake/check", m, pos: true);
    StakeCheck? sc = StakeCheck.fromJson(res);
    if (sc.hasError == true) return;
    if (sc.active == 0) {
      _staking = false;
      _inPoolTotal = sc.inPoolTotal ?? 0.0;
      setState(() {});
    } else {
      _estimated = sc.estimated ?? 0.0;
      _percentage = sc.contribution ?? 0.0;
      _inPoolTotal = sc.inPoolTotal ?? 0.0;
      _amountStaked = sc.amount!.toString();
      _unconfirmedAmount = sc.unconfirmed!;
      _amountReward = _formatDecimal(Decimal.parse(sc.stakesAmount.toString()));
      _staking = true;
      setState(() {});
    }
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
                onRefresh: () => _stakeBloc!.fetchStakeData(_coinActive.id!, 0),
                child: StreamBuilder<ApiResponse<StakingData>>(
                    stream: _stakeBloc!.coinsListStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.completed:
                            return CoinStakeGraph(
                              key: _graphKey,
                              stake: snapshot.data?.data,
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
                  key: const ValueKey<int>(0),
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
                          style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Color(0xFF9BD41E)),
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
                          "${AppLocalizations.of(context)!.stake_staked_amount}:",
                          // textAlign: TextAlign.end,
                          style:
                              TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white.withOpacity(0.4)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: AutoSizeText(
                              _formatPriceString(_amountStaked),
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
                          style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Color(0xFF9BD41E)),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_unconfirmedAmount != 0.0)
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
                                Expanded(
                                  child: AutoSizeText(
                                    "${AppLocalizations.of(context)!.stake_unconfirmed}:",
                                    // textAlign: TextAlign.end,
                                    minFontSize: 8.0,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white.withOpacity(0.4)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: AutoSizeText(
                                    _unconfirmedAmount.toStringAsFixed(3),
                                    maxLines: 1,
                                    minFontSize: 8.0,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                  ),
                                ),
                                Text(
                                  _coinActive.ticker!,
                                  // textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Color(0xFF9BD41E)),
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
                          "${AppLocalizations.of(context)!.stake_reward}:",
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
                          style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Color(0xFF9BD41E)),
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
                                  "${AppLocalizations.of(context)!.staking_total_tokens}:",
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
                                      "${_inPoolTotal.toStringAsFixed(1)} ${_coinActive.ticker!}",
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
                                  "${AppLocalizations.of(context)!.staking_monetary_value}:",
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
                                      "${(_inPoolTotal * _price).toStringAsFixed(2)} USD",
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
                                  "${AppLocalizations.of(context)!.staking_contrib}:",
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
                                      "${_percentage.toStringAsFixed(3)}%",
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
                          // RotatedBox(
                          //   quarterTurns: _detailsExtended ? 2 : 0,
                          //   child: const Icon(
                          //     Icons.arrow_drop_down,
                          //     color: Colors.white54,
                          //     size: 18.0,
                          //   ),
                          // ),
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
                Container(
                  margin: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 5.0),
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: amountEmpty ? Colors.red.shade600 : Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: AutoSizeTextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          try {
                            final text = newValue.text;
                            if (text.isNotEmpty) double.parse(text);
                            return newValue;
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                          return oldValue;
                        }),
                      ],
                      maxLines: 1,
                      minFontSize: 12.0,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white, fontSize: 18.0),
                      autocorrect: false,
                      focusNode: numberFocusNode,
                      controller: _amountController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: amountEmpty ? Colors.red.shade600.withOpacity(0.2) : Colors.black12,
                        contentPadding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white70, fontSize: 14.0),
                        hintText: AppLocalizations.of(context)!.stake_amount,
                        // enabledBorder: const UnderlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.transparent),
                        // ),
                        // focusedBorder: const UnderlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.transparent),
                        // ),
                      ),
                    ),
                  ),
                ),
                PercentSwitchWidget(
                  key: _percentageKey,
                  changePercent: _changePercentage,
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "${AppLocalizations.of(context)!.min_withdraw} $_min | ${AppLocalizations.of(context)!.fees} $_fee ${_coinActive.ticker} \n${AppLocalizations.of(context)!.staking_lock_coins}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white30),
                  )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: const Color(0xFF9BD41E)),
                    child: SlideAction(
                      height: 60.0,
                      sliderButtonIconPadding: 6.0,
                      borderRadius: 10.0,
                      text: "${AppLocalizations.of(context)!.stake_swipe} ${widget.activeCoin.name!}",
                      innerColor: const Color(0xFF9BD41E),
                      outerColor: const Color(0xFF252F45),
                      elevation: 0.5,
                      // submittedIcon: const Icon(Icons.check, size: 30.0, color: Colors.lightGreenAccent,),
                      submittedIcon: const CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.lightGreenAccent,
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
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    AppLocalizations.of(context)!.stake_wait,
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
                                    color: const Color(0xb26cb30b),
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
                                                : AutoSizeText(
                                                    AppLocalizations.of(context)!.stake_get_reward,
                                                    maxLines: 1,
                                                    minFontSize: 8.0,
                                                    style: const TextStyle(
                                                        fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 18.0, color: Colors.white),
                                                  ))),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: FlatCustomButton(
                                onTap: () {
                                  if (!_adjustReward) {
                                    // _unStake(2);
                                    Dialogs.openStakeAdjustment(context, double.parse(_amountStaked), (k) {
                                      Navigator.of(context).pop();
                                      _unStake(2, amount: k);
                                    });
                                  }
                                },
                                radius: 10.0,
                                borderWidth: 2.0,
                                borderColor: const Color(0xFF9BD41E),
                                color: Theme.of(context).canvasColor,
                                child: SizedBox(
                                    height: 45.0,
                                    child: Center(
                                        child: _adjustReward
                                            ? const Padding(
                                                padding: EdgeInsets.all(3.0),
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  color: Colors.white70,
                                                ),
                                              )
                                            : AutoSizeText(
                                                AppLocalizations.of(context)!.st_adjust,
                                                maxLines: 1,
                                                minFontSize: 8.0,
                                                style: const TextStyle(
                                                    fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 18.0, color: Color(0xFF9BD41E)),
                                              ))),
                              )),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: FlatCustomButton(
                                onTap: () {
                                  if (!_loadingCoins) {
                                    _unStake(0);
                                  }
                                },
                                radius: 10.0,
                                borderWidth: 2.0,
                                borderColor: const Color(0xFF9BD41E),
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
                                            : AutoSizeText(
                                                AppLocalizations.of(context)!.stake_get_all,
                                                maxLines: 1,
                                                minFontSize: 8.0,
                                                style: const TextStyle(
                                                    fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 18.0, color: Color(0xFF9BD41E)),
                                              ))),
                              )),
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
    _stakeBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
  }

  _blockSwipe(bool b) {
    widget.blockTouch(b);
  }

  String _formatDecimal(Decimal d) {
    try {
      if (d == Decimal.zero) return "0.0";
      var str = d.toString();
      var split = str.split(".");
      var subs = split[1];
      var count = 0;
      loop:
      for (var i = 0; i < subs.length; i++) {
        if (subs[i] == "0") {
          count++;
        } else {
          break loop;
        }
      }
      if (count > 8) {
        return d.toStringAsExponential(3);
      }
      return _formatPrice(d);
    } catch (e) {
      return "0.0";
    }
  }

  String _formatPrice(Decimal d) {
    try {
      if (d == Decimal.zero) return "0.0";
      var split = d.toString().split('.');
      var decimal = split[1];
      if (decimal.length >= 8) {
        var sub = decimal.substring(0, 8);
        return "${split[0]}.$sub";
      } else {
        return d.toString();
      }
    } catch (e) {
      return d.toString();
    }
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
    if (_amountController.text.isEmpty) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.staking_please_enter);
      _keyStake.currentState!.reset();
      return;
    }
    var amt = double.parse(_amountController.text);
    bool minAmount = amt < _min!;

    if (amt > _free) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.staking_not_enough);
      _keyStake.currentState!.reset();
      return;
    }

    if (widget.depositAddress == null || widget.depositAddress!.isEmpty) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Data err");
      _keyStake.currentState!.reset();
      return;
    }

    if (minAmount) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error,
          AppLocalizations.of(context)!.staking_not_min(_min!.toString(), _coinActive.ticker!));
      _keyStake.currentState!.reset();
      return;
    }

    try {
      await _getStakingDetails();
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      Map<String, dynamic> query = {"coinId": _coinActive.id!, "fee": _fee, "amount": amt, "toAddress": widget.depositPosAddress};

      final response = await _interface.post("Transfers/CreateWithdraw", query);
      var pwid = WithdrawID.fromJson(response);
      Map<String, dynamic> queryID = {
        "id": pwid.data!.pgwIdentifier!,
      };
      var resWith = await _interface.post("Transfers/ConfirmWithdraw", queryID);
      rw = WithdrawConfirm.fromJson(resWith);
      await db.addTX(rw.data!.pgwIdentifier!, _coinActive.id!, double.parse(_amountController.text), widget.depositAddress!);
      problem = serverTypePos;
      Map<String, dynamic> m = {
        "idCoin": _coinActive.id!,
        "depAddr": widget.depositAddress,
        "amount": double.parse(_amountController.text),
        "pwd_id": rw.data!.pgwIdentifier!,
      };
      await _interface.post("stake/set", m, pos: true);
      _getPos();
      _lostPosTX();
    } on BadRequestException catch (r) {
      if (mounted) Navigator.of(context).pop();
      _keyStake.currentState!.reset();
      if (mounted) Dialogs.openAlertBox(context,AppLocalizations.of(context)!.error, r.toString());
    } on ConflictDataException catch (r) {
      if (mounted) Navigator.of(context).pop();
      _keyStake.currentState!.reset();
      var err = json.decode(r.toString());
      if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, err['errorMessage']);
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      _keyStake.currentState!.reset();
      if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "$e\n\n$problem");
    }

    if (rw == null) {
      _keyStake.currentState!.reset();
      if (mounted) Navigator.of(context).pop();
      if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Couldn't send coins for Staking \n\n$serverTypeRckt");
    }

    _amountController.clear();
    _changeFree();
    _keyStake.currentState!.reset();
    await _getStakingDetails();
    _stakeBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
    setState(() {});
    if (mounted) Navigator.of(context).pop();
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
          await _interface.post("stake/confirm", m, pos: true);
          await db.finishTX(pgwid!);
          await Future.delayed(const Duration(seconds: 3));
          _getPos();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  _unStake(int rewardParam, {double amount = 0.0}) async {
    if (_loadingReward || _loadingCoins || _adjustReward) {
      return;
    }
    Dialogs.openWaitBox(context);
    if (rewardParam == 2) {
      _adjustReward = true;
    } else if (rewardParam == 1) {
      _loadingReward = true;
    } else {
      _loadingCoins = true;
    }
    setState(() {});
    try {
      Map<String, dynamic> m = {"idCoin": _coinActive.id!, "rewardParam": rewardParam, "amount": amount};
      await _interface.post("stake/withdraw", m, pos: true);
      _changeFree();
      await _getStakingDetails();
      _stakeBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
      var conf = _coinActive.requiredConfirmations;
      if (rewardParam == 2) {
        _adjustReward = false;
      } else if (rewardParam == 1) {
        _loadingReward = false;
      } else {
        _loadingCoins = false;
      }
      setState(() {});
      if (mounted) {
        Navigator.of(context).pop();
        Dialogs.openAlertBox(
            context, AppLocalizations.of(context)!.alert, AppLocalizations.of(context)!.staking_with_info(conf.toString()));
      }
    } on ConflictDataException catch (e) {
      if (rewardParam == 2) {
        _adjustReward = false;
      } else if (rewardParam == 1) {
        _loadingReward = false;
      } else {
        _loadingCoins = false;
      }
      setState(() {});
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, e.toString());
    } catch (e) {
      if (rewardParam == 2) {
        _adjustReward = false;
      } else if (rewardParam == 1) {
        _loadingReward = false;
      } else {
        _loadingCoins = false;
      }
      setState(() {});
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

  _changePercentage(double d) {
    _amountController.text = _formatPriceString(((_free - _fee!) * d).toString());
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
      _getPos();
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
