import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/NetInterface/interface.dart';
import 'package:rocketbot/bloc/get_transaction_bloc.dart';
import 'package:rocketbot/cache/price_graph_cache.dart';
import 'package:rocketbot/models/balance_portfolio.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/models/transaction_data.dart';
import 'package:rocketbot/widgets/coin_deposit_view.dart';
import 'package:rocketbot/widgets/coin_withdrawal_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/coins_price_bloc.dart';
import '../component_widgets/button_neu.dart';
import '../component_widgets/container_neu.dart';
import '../models/balance_list.dart';
import '../models/coin.dart';
import '../netInterface/api_response.dart';
import '../widgets/coin_price_graph.dart';
import '../widgets/price_badge.dart';
import '../widgets/time_range_switch.dart';

class CoinScreen extends StatefulWidget {
  final Coin activeCoin;
  final VoidCallback goBack;
  final List<CoinBalance>? allCoins;
  final Function(double free) changeFree;
  final Function(Coin? c) setActiveCoin;
  final Function(bool touch) blockTouch;
  final double? free;
  final Function goToStaking;
  final String? posDepositAddr;

  const CoinScreen(
      {Key? key,
      required this.activeCoin,
      required this.changeFree,
      this.allCoins,
      required this.goBack,
      required this.setActiveCoin,
      required this.blockTouch,
      required this.free,
        required this.goToStaking, this.posDepositAddr})
      : super(key: key);

  @override
  CoinScreenState createState() => CoinScreenState();
}

class CoinScreenState extends State<CoinScreen> with SingleTickerProviderStateMixin {
  final _graphKey = GlobalKey<CoinPriceGraphState>();
  final NetInterface _interface = NetInterface();
  late List<CoinBalance> _listCoins;
  CoinBalance? _balanceData;
  late Coin _coinActive;
  Decimal _percentage = Decimal.parse((0.0).toString());

  CoinPriceBloc? _priceBlock;
  TransactionBloc? _txBloc;

  Decimal totalCoins = Decimal.zero;
  Decimal totalUSD = Decimal.zero;
  Decimal usdCost = Decimal.zero;

  double _coinNameOpacity = 0.0;
  double _free = 0.0;

  bool portCalc = false;

  PriceData? _priceData;
  String? _posAddr;

  @override
  void initState() {
    super.initState();
    _free = widget.free!;
    _posAddr = widget.posDepositAddr;
    _coinActive = widget.activeCoin;
    _listCoins = widget.allCoins!;
    _balanceData = _listCoins.singleWhere((element) => element.coin!.id! == _coinActive.id!);
    _calculatePortfolio();
    _priceBlock = CoinPriceBloc(widget.activeCoin.cryptoId!, widget.activeCoin.id!);
    _txBloc = TransactionBloc(widget.activeCoin);
    _getGraphData();
  }

  @override
  void dispose() {
    // _listCoins.clear();
    _priceBlock!.dispose();
    _txBloc!.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setAddr(String? addr) {
    setState(() {
      _posAddr = addr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 25,
                    child: NeuButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20.0,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(AppLocalizations.of(context)!.tx,
                      style: Theme.of(context).textTheme.headline4),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
            IgnorePointer(
              ignoring: _posAddr != null ? false : true,
              child: Opacity(
                opacity: _posAddr != null ? 1.0 : 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    splashColor: const Color(0xFF812D88),
                    borderRadius:BorderRadius.circular(10.0),
                    onTap: () {
                      widget.goToStaking();
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10.0),
                        gradient: const LinearGradient(colors: [
                          Color(0xFFF05523),
                          Color(0xFF812D88),
                        ]
                        ),
                      ),
                      child: SizedBox(
                        height: 75,
                        child: Row(
                          children: [
                            Opacity(
                              opacity: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text(
                                    "Token ${_posAddr == null ? "not" : ""} available for",
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    "Staking",
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ],),
                              ),
                            ),
                          const Expanded(child: SizedBox(),),
                          Opacity(
                            opacity: 0.9,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 25.0, 12.0),
                              child: Image.asset("images/staking_icon.png"),
                            ),
                          ),
                        ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0, top: 5.0, bottom: 5.0),
              child: Row(
                children: [
                  if (_listCoins.isNotEmpty)
                    SizedBox(
                      height: 30,
                      child: NeuContainer(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Center(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Coin>(
                                  value: _coinActive,
                                  isDense: true,
                                  onChanged: (Coin? coin) {
                                    setState(() {
                                      widget.setActiveCoin(coin);
                                      _coinActive = coin!;
                                      _balanceData = _listCoins.singleWhere((element) => element.coin!.id! == _coinActive.id!);
                                      _graphKey.currentState!.updatePrices(_balanceData!.priceData?.historyPrices);
                                      _priceBlock!.changeCoin(coin.cryptoId!, coin.id!);
                                      _coinNameOpacity = 0.0;
                                      _txBloc!.changeCoin(coin);
                                    });
                                    _calculatePortfolio();
                                  },
                                  items: _listCoins
                                      .map((e) => DropdownMenuItem(value: e.coin!, child: SizedBox(width: 100, child: Text(e.coin!.cryptoId!))))
                                      .toList(),
                                ),
                              ),
                            ),
                          )),
                    )
                  else
                    Container(),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  SizedBox(
                      height: 30,
                      child: TimeRangeSwitcher(
                        changeTime: _changeTime,
                      )),
                  // Expanded(
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(right: 8.0),
                  //       child: SizedBox(
                  //         height: 30,
                  //         width: 25,
                  //         child: NeuButton(
                  //           onTap: () {},
                  //           icon: const Icon(
                  //             Icons.more_vert,
                  //             color: Colors.white70,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            Stack(
              children: [
                SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: _priceData != null
                        ? CoinPriceGraph(
                            key: _graphKey,
                            prices: _priceData?.historyPrices,
                            time: 24,
                            blockTouch: _blockSwipe,
                          )
                        : HeartbeatProgressIndicator(
                            startScale: 0.01,
                            endScale: 0.4,
                            child: const Image(
                              image: AssetImage('images/rocketbot_logo.png'),
                              color: Colors.white30,
                            ),
                          )),
                AnimatedOpacity(
                  opacity: _coinNameOpacity,
                  duration: const Duration(milliseconds: 300),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          children: [
                            Text(
                              _coinActive.name!,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1.5),
                                  child: Text(
                                    "\$${_formatDecimal(usdCost)}",
                                    style: Theme.of(context).textTheme.headline2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: PriceBadge(
                                    percentage: _percentage,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            SizedBox(
                              width: 320,
                              child: AutoSizeText(
                                '${_formatPrice(totalCoins)} ${_coinActive.cryptoId!}',
                                style: Theme.of(context).textTheme.headline1,
                                maxLines: 1,
                                minFontSize: 8,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "\$${_formatPrice(totalUSD)}",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                const SizedBox(width: 5.0),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white30, width: 0.5)),
              ),
            ),
            Flexible(
              child: RefreshIndicator(
                onRefresh: () {
                  _changeFree();
                  return _txBloc!.fetchTransactionData(widget.activeCoin, force: true);
                },
                child: StreamBuilder<ApiResponse<List<TransactionData>>>(
                  stream: _txBloc!.coinsListStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.loading:
                          return Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: SizedBox(
                              child: portCalc
                                  ? Container()
                                  : const Center(
                                      child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    )),
                            ),
                          );
                        case Status.completed:
                          if (snapshot.data!.data!.isEmpty) {
                            return Center(
                                child: Text(
                              AppLocalizations.of(context)!.no_tx,
                              style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white12),
                            ));
                          } else {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.data!.length,
                                itemBuilder: (ctx, index) {
                                  // print(snapshot.data!.data![index].transactionId);
                                  if (snapshot.data!.data![index].toAddress == null) {
                                    return CoinDepositView(
                                      price: _balanceData?.priceData,
                                      data: snapshot.data!.data![index],
                                    );
                                  } else {
                                    return CoinWithdrawalView(price: _balanceData?.priceData, data: snapshot.data!.data![index]);
                                  }
                                });
                          }
                        // break;
                        case Status.error:
                          return Center(
                              child: Text(
                            AppLocalizations.of(context)!.tx_problem,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white12),
                          ));
                        // print(snapshot.error);
                        // break;
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _changeTime(int time) {
    setState(() {
      _graphKey.currentState!.changeTime(time);
    });
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

  _changeFree() async {
    var preFree = 0.0;
    var resB = await _interface.get("User/GetBalance?coinId=${_coinActive.id!}");
    var rs = BalancePortfolio.fromJson(resB);
    preFree = rs.data!.free!;
    setState(() {
      _free = preFree;
    });
    widget.changeFree(_free);
    _calculatePortfolio();
  }

  _getGraphData() async {
    var p = await PriceGraphCache.getAllRecords(_coinActive.id!);
    setState(() {
      _priceData = p;
    });
    if (_graphKey.currentState != null) {
      _graphKey.currentState!.changeCoin(_priceData!.historyPrices!);
    }
    // print(p.toJson());
  }

  changeFree(double free) {
    setState(() {
      _free = free;
    });
  }

  _calculatePortfolio() async {
    _getGraphData();
    setState(() {
      portCalc = false;
    });
    Decimal? freeCoins = Decimal.parse(_free.toString());
    try {
      for (var element in _listCoins) {
        if (element.coin == _coinActive) {

          Decimal? priceUSD = element.priceData!.prices!.usd!;
          Decimal? priceBTC = element.priceData!.prices!.btc!;
          _percentage = element.priceData!.priceChange24HPercent!.usd!;
          usdCost = element.priceData!.prices!.usd!;

          totalCoins = freeCoins;
          totalUSD = freeCoins * priceUSD;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _coinNameOpacity = 1.0;
      });
    });
  }
}
