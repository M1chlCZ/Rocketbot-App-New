import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import 'package:rocketbot/screens/socials_screen.dart';
import 'package:rocketbot/widgets/coin_list_view.dart';
import 'package:rocketbot/widgets/earnings_chart.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> with AutomaticKeepAliveClientMixin<EarningsScreen>{
  NetInterface interface = NetInterface();
  List<Sector> list = [];
  double totalUSD = 0.0;
  StakeBalanceBloc? _bloc;
  PosCoinsList? posCoin;

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
      Color(0xE690C8AC),
      Color(0xE673A9AD),
      Color(0xE6D08770),
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
    var res = await interface.get("/earnings", pos: true);
    EarnRes ea = EarnRes.fromJson(res);

    if (ea.earnings != null) {
      for (var ee in ea.earnings!) {
        var val = ee.amount!;
        CoinBalance bal = balList.firstWhere((element) => element.coin!.id! == ee.idCoin);
        Coin c = bal.coin!;
        totalUSD += bal.priceData!.prices!.usd!.toDouble() * ee.amount!.toDouble();
        Sector s = Sector(val: val, col: colors[i], nam: c.cryptoId!, rad: 15);
        list.add(s);
        i++;
      }
    }
    if (list.isNotEmpty) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          Text("Earnings", style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white)),
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
                      height: 320.0,
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              opacity: 1.0,
                              filterQuality: FilterQuality.high,
                              alignment: Alignment(0.0, 1.0),
                              fit: BoxFit.cover,
                              image: AssetImage("images/earnings_cover.png")),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: const Color(0x5FFCFCFC), width: 1.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!.income.toLowerCase().capitalize(),
                            style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 40.0, color: Colors.black45),
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
                                      style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 18.0, color: Colors.black45),
                                    ),
                                    const SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(
                                      "${totalUSD.toStringAsFixed(2)} \$",
                                      style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w800, fontSize: 18.0, color: const Color(0xFF9EC73F)),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 5.0),
                                  child: Divider(height: 2.0, color: Colors.black38,),
                                ),
                                SizedBox(
                                    height: 200,
                                    child: EarningsChart(list)),
                              ],
                            )
                          else
                            const SizedBox(
                              height: 200,
                              child:
                               Center(child: CircularProgressIndicator(color: Colors.black54,),),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
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
    if (mounted) {
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
      final response = await interface.post("Transfers/CreateDepositAddress", request, debug: true);
      var d = DepositAddress.fromJson(response);
      return d.data!.address!;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return "";
    }
  }

  _blockTouch(bool touch) {

  }

  @override
  bool get wantKeepAlive => false;
}
