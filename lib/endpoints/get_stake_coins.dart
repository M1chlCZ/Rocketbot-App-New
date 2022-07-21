import 'package:flutter/foundation.dart';
import 'package:rocketbot/cache/balances_cache.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/pos_coins_list.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/support/secure_storage.dart';

class StakeBalances {
  final NetInterface _interface = NetInterface();
  PosCoinsList? pl;

  List<CoinBalance> finalList = [];

  Future<List<CoinBalance>?> fetchStakeBalances() async {
    // print("|FIRST STAKING BEGIN| " + DateTime.now().toString());
    pl = await _getPosCoins();
    String? posToken = await SecureStorage.readStorage(key: NetInterface.posToken);
    if (kDebugMode) {
      print(posToken ?? "NULL TOKEN");
    }
    if (pl == null) {
      await NetInterface.registerPosHandle();
      pl = await _getPosCoins();
    } else if (pl == null && posToken != null) {
      await NetInterface.registerPosHandle();
      pl = await _getPosCoins();
    }
    // print("|SECOND STAKING DONE| " + DateTime.now().toString());
    List<CoinBalance> list = await BalanceCache.getAllRecords(forceRefresh: false);
    // print("|THIRD COIN BALANCEs START| " + DateTime.now().toString());
    for (var i = 0; i < list.length; i++) {
      var coin = list[i].coin!;
      int index = -1;
      if (pl != null) {
        index = pl!.coins!.indexWhere((element) => element.idCoin == coin.id);
      }
      if (index != -1) {
        list[i].setStaking(true);
        list[i].setPosCoin(pl!.coins![index]);
        finalList.add(list[i]);
      }
    }
    // print("|FIFTH COIN BALANCEs DONE| " + DateTime.now().toString());
    return finalList;
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
}
