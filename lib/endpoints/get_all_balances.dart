import 'package:flutter/foundation.dart';
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
    // debugPrint("|FIRST STAKING BEGIN| " + DateTime.now().toString());
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
    // debugPrint("|SECOND STAKING DONE| " + DateTime.now().toString());
    List<CoinBalance> list = await BalanceCache.getAllRecords(forceRefresh: force);
    // debugPrint("|THIRD COIN BALANCEs START| " + DateTime.now().toString());
    // var hl = await _getAmountCoins();
    for (var i = 0; i < list.length; i++) {
      var coin = list[i].coin!;
      int index = -1;
      if (pl != null) {
        index = pl!.coins!.indexWhere((element) => element.idCoin == coin.id);
      }
      if (index != -1) {
        list[i].setStaking(true);
        list[i].setPosCoin(pl!.coins![index]);
      } else {
        list[i].setStaking(false);
      }
    }
    // print("|FIFTH COIN BALANCEs DONE| " + DateTime.now().toString());
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
