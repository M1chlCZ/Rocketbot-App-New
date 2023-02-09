import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/bloc/get_transaction_bloc.dart';
import 'package:rocketbot/cache/price_graph_cache.dart';
import 'package:rocketbot/models/balance_portfolio.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/models/exchanges.dart';
import 'package:rocketbot/models/transaction_data.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screens/exchange_list_screen.dart';
import 'package:rocketbot/screens/ramper_screen.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/coin_deposit_view.dart';
import 'package:rocketbot/widgets/coin_withdrawal_view.dart';
import 'package:rocketbot/widgets/horizontal_list_tile.dart';
import 'package:rocketbot/widgets/price_range_switch.dart';
import 'package:rocketbot/widgets/switching_button.dart';

import '../bloc/coins_price_bloc.dart';
import '../models/balance_list.dart';
import '../models/coin.dart';
import '../netInterface/api_response.dart';
import '../widgets/coin_price_graph.dart';
import '../widgets/price_badge.dart';

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
  final String? depositAddr;
  final bool masternode;

  const CoinScreen(
      {Key? key,
      required this.activeCoin,
      required this.changeFree,
      this.allCoins,
      required this.goBack,
      required this.setActiveCoin,
      required this.blockTouch,
      required this.free,
      required this.goToStaking,
      this.posDepositAddr,
      required this.masternode,
        this.depositAddr})
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
  ScrollController sc = ScrollController();
  ScrollController scrollCtrl = ScrollController();
  bool isScrollIdle = true;
  int _currentIndex = 0;

  int loadedItems = 8;
  int dataLength = 0;

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

  bool _preventScroll = false;

  double pr = 0.0;

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
    sc.addListener(_scrollListener);
    _getActiveCoinPosition();
  }

  @override
  void dispose() {
    // _listCoins.clear();
    _priceBlock!.dispose();
    _txBloc!.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    _txBloc!.fetchTransactionData(_coinActive, force: true);
    await getFree();
  }

  _getActiveCoinPosition() {
    Future.delayed(const Duration(milliseconds: 10), () {
      var i = _listCoins.indexWhere((element) => element.coin!.id! == _coinActive.id!);
      _jumpTo(i);
    });
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

  void _scrollListener() {
    if (sc.position.pixels >= (sc.position.maxScrollExtent - 250)) {
      if (loadedItems < dataLength) {
        var rem = dataLength - loadedItems;
        if (rem < 10) {
          setState(() {
            loadedItems += rem;
          });
        } else {
          setState(() {
            loadedItems += 10;
          });
        }
      }
      // _suggestionBloc.fetchSuggestions();
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = MediaQuery.of(context).size.width * 0.195;
    return Material(
      child: RefreshIndicator(
        notificationPredicate: (not) {
          return true;
        },
        onRefresh: refresh,
        child: SingleChildScrollView(
          controller: sc,
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
                      child: FlatCustomButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 24.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        AppLocalizations.of(context)!.tx,
                        style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Visibility(
                    visible: _posAddr != null ? true : false,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0, top: 2.0),
                        child: Opacity(
                          opacity: 1.0,
                          child: SizedBox(
                              width: 100,
                              height: 90,
                              child: Image.asset(
                                "images/hand.png",
                              )),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _posAddr == null ? true : false,
                    child: const SizedBox(
                      width: 100,
                      height: 92,
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
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            widget.goToStaking();
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: const RadialGradient(center: Alignment(1.5, -3.0), radius: 5.0, colors: [
                                Color(0xFF7388FF),
                                Color(0xFFCA73FF),
                                Color(0xFFFF739D),
                              ]),
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Token${_posAddr == null ? " not" : ""} available for",
                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            "Staking${widget.masternode ? " & MN hosting" : ""}",
                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 10.0, top: 10.0, bottom: 5.0),
                child: _listCoins.isNotEmpty
                    ? SizedBox(
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Center(
                              child: NotificationListener<ScrollNotification>(
                            onNotification: (scrollNotification) {
                              var pp = (scrollNotification.metrics.pixels + 20.0) / pr;
                              var px = pp.toInt();

                              if (px != _currentIndex) {
                                _currentIndex = px;
                                setState(() {});
                              }
                              isScrollIdle = false;

                              if (scrollNotification is ScrollEndNotification) {
                                if (!_preventScroll) {
                                  _preventScroll = true;
                                  _onEndScroll(scrollNotification.metrics);
                                }
                                return true;
                              }
                              // Basically you need something like:
                              // final _index = scrollOffset (or position) / item height;
                              return true;
                            },
                            child: ListView.builder(
                                itemCount: _listCoins.length + 3,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                controller: scrollCtrl,
                                itemBuilder: (context, index) {
                                  if (index > _listCoins.length - 1) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.2,
                                    );
                                  }
                                  return HorizontalListView(
                                      key: ValueKey<String>(_listCoins[index].coin!.ticker!),
                                      coin: _listCoins[index].coin!,
                                      callBack: (int i) {
                                        _jumpTo(i);
                                      },
                                      index: index,
                                      active: index == _currentIndex ? true : false
                                      // active: _listCoins[index].coin! == _coinActive ? true : false,
                                      );
                                }),
                          )),
                        ),
                      )
                    : Container(),
              ),
              Stack(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: 200,
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
                                style: Theme.of(context).textTheme.displayMedium,
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
                                      style: Theme.of(context).textTheme.displayMedium,
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
                                height: 20.0,
                              ),
                              SizedBox(
                                width: 320,
                                child: AutoSizeText(
                                  '${_formatPrice(totalCoins)} ${_coinActive.cryptoId!}',
                                  style: Theme.of(context).textTheme.displayLarge,
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
                                    style: Theme.of(context).textTheme.displayMedium,
                                  ),
                                  const SizedBox(width: 5.0),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              SwitchingButton(
                                onPressed: () {
                                  _getExchange(_coinActive.id!);
                                },
                              ),
                              // FlatCustomButton(
                              //   height: 30,
                              //   width: 120,
                              //   radius: 8.0,
                              //   onTap: (){
                              //
                              // },
                              //   color: const Color(0xFF9BD41E),
                              //   child: Text("Buy ${_coinActive.ticker!}", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14.0, color: const Color(0xFF252F45),fontWeight: FontWeight.w600),),
                              // )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
              PriceRangeSwitcher(
                changeTime: _changeTime,
                color: const Color(0xFF9D9BFD),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white30, width: 0.5)),
                ),
              ),
              Flexible(
                child: RefreshIndicator(
                  onRefresh: () {
                    getFree();
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
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white12),
                              ));
                            } else {
                              dataLength = snapshot.data!.data!.length;
                              if (dataLength < loadedItems) {
                                loadedItems = dataLength;
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: loadedItems,
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
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white12),
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

  _onEndScroll(ScrollMetrics metrics) {
    _setOnEnd();
  }

  void _setOnEnd() async {
    if (_currentIndex < 0) {
      _currentIndex == 0;
    }
    _setActiveCoin(_listCoins[_currentIndex].coin);
    _txBloc!.changeCoin(_listCoins[_currentIndex].coin!);
    Future.delayed(const Duration(milliseconds: 50), () async {
      var scrollPosition = pr * _currentIndex;
      await scrollCtrl.animateTo(scrollPosition, duration: const Duration(milliseconds: 800), curve: Curves.elasticOut);
      Future.delayed(const Duration(milliseconds: 10), () {
        _preventScroll = false;
      });
    });
  }

  void _jumpTo(int index) {
    _currentIndex = index;
    Future.delayed(const Duration(milliseconds: 50), () async {
      var scrollPosition = pr * _currentIndex;
      await scrollCtrl.animateTo(scrollPosition, duration: const Duration(milliseconds: 800), curve: Curves.elasticOut);
      Future.delayed(const Duration(milliseconds: 10), () {
        _preventScroll = false;
      });
    });
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

  getFree() async {
    var preFree = 0.0;
    var resB = await _interface.get("User/GetBalance?coinId=${_coinActive.id!}");
    var rs = BalancePortfolio.fromJson(resB);
    preFree = rs.data!.free!;
    setState(() {
      _free = preFree;
    });
    widget.changeFree(_free);
    _txBloc!.fetchTransactionData(_coinActive, force: true);
    _calculatePortfolio();
  }

  Future<int> getUserID() async {
    try {
      var resB = await _interface.get("auth/id", pos: true);
      return resB['id'];
    } catch (e) {
      print(e);
      return 0;
    }
  }

  _getGraphData() async {
    var p = await PriceGraphCache.getAllRecords(_coinActive.id!);
    setState(() {
      _priceData = p;
    });
    if (_graphKey.currentState != null) {
      _graphKey.currentState?.changeCoin(_priceData?.historyPrices);
    }
    // print(p.toJson());
  }

  changeFree(double free) {
    setState(() {
      _free = free;
    });
  }

  void _setActiveCoin(Coin? coin) {
    setState(() {
      widget.setActiveCoin(coin);
      _coinActive = coin!;
      _balanceData = _listCoins.singleWhere((element) => element.coin!.id! == _coinActive.id!);
      _graphKey.currentState?.updatePrices(_balanceData!.priceData?.historyPrices);
      _priceBlock!.changeCoin(coin.cryptoId!, coin.id!);
      _coinNameOpacity = 0.0;
      _txBloc!.changeCoin(coin);
    });
    _calculatePortfolio();
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
          Decimal? priceUSD = element.priceData?.prices?.usd ?? Decimal.zero;
          // Decimal? priceBTC = element.priceData!.prices!.btc!;
          _percentage = element.priceData?.priceChange24HPercent?.usd ?? Decimal.zero;
          usdCost = element.priceData?.prices?.usd ?? Decimal.zero;

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

  void _getExchange(int idCoin) async {
    int userID = await getUserID();
    print("get addr ${widget.activeCoin.ticker} userID: $userID");
    try {
      List<Exchange> l = [];
      List<dynamic> res = await _interface.post("exchanges", {"idCoin": idCoin}, pos: true, debug: true);
      res.map((e) => Exchange.fromJson(e)).forEach((element) {
        l.add(element);
      });
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExchangeListScreen(idCoin: _coinActive.ticker ?? "", exchanges: l),
          ),
        );
      }
    } catch (e) {
      if (e.toString().contains("This coin is not an exchange")) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RamperScreen(userID: userID, coin: widget.activeCoin,),
            ),
          );
        }
      }
    }
  }
}
