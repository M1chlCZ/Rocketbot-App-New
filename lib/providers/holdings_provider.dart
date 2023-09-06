import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/cache/balances_cache.dart';
import 'package:rocketbot/models/Holdings_res.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/pos_coins_list.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/support/secure_storage.dart';

class CoinBalances {
  final NetInterface _interface = NetInterface();
  PosCoinsList? pl;

  Future<List<CoinBalance>?> fetchAllBalances(bool force) async {
    String? posToken;
    try {
      pl = await _getPosCoins();
      posToken = await SecureStorage.readStorage(key: NetInterface.posToken);
      if (kDebugMode) {
        print(posToken ?? "NULL TOKEN");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    if (pl == null) {
      await NetInterface.registerPosHandle();
      pl = await _getPosCoins();
    } else if (pl == null && posToken != null) {
      await NetInterface.registerPosHandle();
      pl = await _getPosCoins();
    }
    List<CoinBalance> list = await BalanceCache.getAllRecords(forceRefresh: false);
    var hl = await _getAmountCoins();
    for (var i = 0; i < list.length; i++) {
      var coin = list[i].coin!;
      int index = -1;
      if (pl != null) {
        index = pl!.coins!.indexWhere((element) => element.idCoin == coin.id);
      }
      if (index != -1) {
        list[i].setStaking(true);
        list[i].setPosCoin(pl!.coins![index]);
        if (hl != null) {
          var index2 = hl.holdings!.indexWhere((element) => element.idCoin == coin.id);
          if (index2 != -1) {
            list[i].posCoin!.setAmount(hl.holdings![index2].amount!);
          }
        }
      } else {
        list[i].setStaking(false);
      }
    }
    print("|FIFTH COIN BALANCEs DONE| ${DateTime.now()}");
    return list;
  }


  Future<PosCoinsList?> _getPosCoins() async {
    try {
      var response = await _interface.get("coin/get", pos: true);
      var p = PosCoinsList.fromJson(response);
      return p;
    } catch (e) {
      return null;
    }
  }

  Future<HoldingsRes?> _getAmountCoins() async {
    try {
      var response = await _interface.get("holdings", pos: true);
      var p = HoldingsRes.fromJson(response);
      return p;
    } catch (e) {
      return null;
    }
  }
}

final holdingAmountProvider = FutureProvider<Map<String, double>>((ref) async {
final holdings = await CoinBalances().fetchAllBalances(false);
var totalUSD = 0.0;
var totalBTC = 0.0;
var totalUSDYIELD = 0.0;
var totalBTCYIELD = 0.0;
for (var element in holdings!) {
double? freeCoins = element.free ?? 0;
double? freeMNCoins = element.posCoin?.amount ?? 0;
double? priceUSD = element.priceData?.prices?.usd!.toDouble();
double? priceBTC = element.priceData?.prices?.btc!.toDouble();
if (priceUSD != null && priceBTC != null) {
double usd = freeCoins * priceUSD;
totalUSD += usd;
double btc = freeCoins * priceBTC;
totalBTC += btc;
double usdMN = freeMNCoins * priceUSD;
totalUSDYIELD += usdMN;
double btcMN = freeMNCoins * priceBTC;
totalBTCYIELD += btcMN;
}
}
Map<String, double> m = {
"totalUSD": totalUSD,
"totalBTC": totalBTC,
"totalUSDYIELD": totalUSDYIELD,
"totalBTCYIELD": totalBTCYIELD,
};
return m;
});


// final holdingProvider = FutureProvider<Map<String, double>>((ref) async {
// });
