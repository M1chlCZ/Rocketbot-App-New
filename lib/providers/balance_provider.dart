import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/cache/balances_cache.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/providers/network_provider.dart';

final balanceProvider = FutureProvider.family<CoinBalance?, int>((ref, idCoin) async {
  try {
    dynamic response = await ref.read(networkProvider).get("User/GetBalance", request: "coinId=$idCoin", pos: false, debug: true );
    var bal = CoinBalance.fromJson(response);
    return bal;
  } catch (e) {
    print(e);
    return null;
  }
});

final balancesProvider = FutureProvider<List<CoinBalance>>((ref) async {
  try {
    List<CoinBalance> list = await BalanceCache.getAllRecords(forceRefresh: false);
    if (list.isNotEmpty) {
      List<CoinBalance> l = [];
      for (var bl in list) {
            if (bl.free != 0) {
              l.add(bl);
            }
          }
      return l;
    }
    return [];
  } catch (e) {
    print(e);
    return [];
  }
});

// class MyDropdownButtonController extends StateNotifier<List<CoinBalance>> {
//   final _entries = <CoinBalance>[];
//
//   MyDropdownButtonController() : super([]);
//
//   void onInit() async {
//     List<CoinBalance> list = await BalanceCache.getAllRecords(forceRefresh: false);
//     if (list.isNotEmpty) {
//       List<CoinBalance> l = [];
//       for (var bl in list) {
//         if (bl.free != 0) {
//           _entries.add(bl);
//         }
//       }
//     }
//     state = _entries;
//   }
// }

final dropdownProvider = StateNotifierProvider<DropDownController, AsyncValue<List<CoinBalance>>>((ref) {;
  return DropDownController();
});

class DropDownController extends StateNotifier<AsyncValue<List<CoinBalance>>> {
  final _entries = <CoinBalance>[];

  DropDownController() : super(const AsyncLoading());

  void getData() async {
    _entries.clear();
    List<CoinBalance> list = await BalanceCache.getAllRecords(forceRefresh: false);

    if (list.isNotEmpty) {
      _entries.addAll(list);
    }
    state = AsyncValue.data(_entries);
  }
}