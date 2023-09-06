import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/bloc/stake_balance_block.dart';
import 'package:rocketbot/cache/balances_cache.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/deposit_address.dart';
import 'package:rocketbot/models/earn_res.dart';
import 'package:rocketbot/models/pos_coins_list.dart';
import 'package:rocketbot/models/sector.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screens/farm_main_screen.dart';
import 'package:rocketbot/widgets/coin_list_view.dart';
import 'package:rocketbot/widgets/earnings_chart.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> with AutomaticKeepAliveClientMixin<EarningsScreen> {
  NetInterface interface = NetInterface();
  List<Sector> list = [];
  double totalUSD = 0.0;
  StakeBalanceBloc? _bloc;
  PosCoinsList? posCoin;
  bool empty = false;

  @override
  void initState() {
    super.initState();
    getEarnings();
    _bloc = StakeBalanceBloc();
    _getPosList();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  _getPosList() async {
    posCoin = await _getPosCoins();
  }

  Future<PosCoinsList?> _getPosCoins() async {
    try {
      var response = await interface.get("coin/get", pos: true);
      var p = PosCoinsList.fromJson(response);
      return p;
    } catch (e) {
      return null;
    }
  }

  void getEarnings() async {
    List<Color> colors = const [
      Color(0xE6A6D23F),
      Color(0xE66B3FD2),
      Color(0xE6D23FA6),
      Color(0xE6EBCB8B),
      Color(0xE6B48EAD),
      Color(0xE6BF616A),
      Color(0xE6A3BE8C),
      Color(0xE6D08770),
      Color(0xE6EBCB8B),
      Color(0xE6B48EAD),
    ];
    List<CoinBalance> balList = await BalanceCache.getAllRecords(forceRefresh: true);

    int i = 0;
    var res = await interface.get("earnings", pos: true, debug: false);
    EarnRes ea = EarnRes.fromJson(res);

    if (ea.earnings != null) {
      for (var ee in ea.earnings!) {
        var val = ee.amount!;
        CoinBalance? bal;
        try {
          bal = balList.firstWhere((element) => element.coin!.id! == ee.idCoin);
        } catch (e) {
          continue;
        }
        Coin c = bal.coin!;
        totalUSD += bal.priceData!.prices!.usd!.toDouble() * ee.amount!.toDouble();
        Sector s = Sector(val: val, col: colors[i], nam: c.ticker!, rad: 15);
        list.add(s);
        i++;
      }
    }
    if (list.isNotEmpty) {
      setState(() {
        empty = false;
      });
    } else {
      setState(() {
        empty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            color: const Color(0xFF9D9BFD),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 0.0),
                      child: Row(
                        children: [
                          Text("Earnings", style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white)),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      height: 252.0,
                      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(center: Alignment(0.8, 1.0), radius: 1.5, colors: [
                          Color(0xFF346CBD),
                          Color(0xFF9D9BFD),
                        ]),
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.white24, width: 1.0),
                        boxShadow: [
                          const BoxShadow(color: Colors.black26, blurRadius: 1.8, spreadRadius: 0.5),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                            offset: const Offset(0.0, 0.0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(width: 40, child: Image.asset("images/equity.png", color: Colors.white54, fit: BoxFit.fitWidth)),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              if (list.isNotEmpty)
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${_getMonth()} ${AppLocalizations.of(context)!.income}: ",
                                          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18.0, color: Colors.white70),
                                        ),
                                        const SizedBox(
                                          width: 2.0,
                                        ),
                                        Text(
                                          "${totalUSD.toStringAsFixed(2)} \$",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(fontWeight: FontWeight.w800, fontSize: 18.0, color: const Color(0xFFC3F649)),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 5.0),
                                      child: Divider(
                                        height: 2.0,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 200,
                                            child: Center(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.1),
                                                              blurRadius: 2.0,
                                                              spreadRadius: 0.5,
                                                              offset: const Offset(0.0, 0.0),
                                                            ),
                                                          ],
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          gradient: LinearGradient(
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomRight,
                                                            colors: [
                                                              list[index].col.withOpacity(1.0),
                                                              list[index].col.withOpacity(0.8),
                                                            ],
                                                          ),
                                                        ),
                                                        height: 30,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              AutoSizeText(
                                                                list[index].nam,
                                                                maxLines: 1,
                                                                minFontSize: 4.0,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .displaySmall!
                                                                    .copyWith(fontSize: 12.0, color: Colors.white70),
                                                              ),
                                                              AutoSizeText(
                                                                list[index].val.toString(),
                                                                maxLines: 1,
                                                                minFontSize: 4.0,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .displaySmall!
                                                                    .copyWith(fontSize: 14.0, color: Colors.white70),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const Divider(
                                                        height: 5.0,
                                                        color: Colors.transparent,
                                                      ),
                                                    ],
                                                  );
                                                },
                                                itemCount: list.length,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 200, width: 200, child: EarningsChart(list)),
                                      ],
                                    ),
                                  ],
                                )
                              else if (empty)
                                SizedBox(
                                  height: 230,
                                  child: Center(
                                    child: Text(
                                      "No data for earnings available",
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18.0, color: Colors.white70),
                                    ),
                                  ),
                                )
                              else
                                const SizedBox(
                                  height: 230,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                                  // PriceGraphCache.refreshAllRecords();
                                  // if (_listCoins == null) {
                                  //   _listCoins = snapshot.data!.data!;
                                  //   _calculatePortfolio();
                                  // }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
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
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonth() {
    String languageCode = Localizations.localeOf(context).languageCode;
    DateFormat dateFormat = DateFormat.MMMM(languageCode);
    String thisMonth = dateFormat.format(DateTime.now());
    return thisMonth;
  }

  _changeCoin(CoinBalance h) async {
    var depAddr = await _getDepositAddr(h.coin!.id!);
    if (context.mounted) {
      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
        return FarmMainScreen(
          changeFree: _changeFree,
          depositAddress: depAddr,
          depositPosAddress: h.posCoin!.depositAddr!,
          activeCoin: h.coin!,
          coinBalance: h,
          free: h.free!,
          blockTouch: _blockTouch,
          masternode: posCoin!.coinsMn!.contains(h.coin?.id),
        );
      }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      }));
    }
  }

  void _changeFree(double free) {
    // _free = free;
    // widget.refreshList();
  }

  Future<String> _getDepositAddr(int coinID) async {
    Map<String, dynamic> request = {
      "coinId": coinID,
    };
    try {
      final response = await interface.post("Transfers/CreateDepositAddress", request, debug: false);
      var d = DepositAddress.fromJson(response);
      return d.data!.address!;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return "";
    }
  }

  _blockTouch(bool touch) {}

  @override
  bool get wantKeepAlive => true;
}
