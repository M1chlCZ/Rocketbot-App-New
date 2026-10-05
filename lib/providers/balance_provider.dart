import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/cache/balances_cache.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/providers/network_provider.dart';

final balanceProvider = FutureProvider.family<CoinBalance?, int>((ref, idCoin) async {
  try {
    dynamic response = await ref.read(networkProvider).get("User/GetBalance", request: "coinId=$idCoin", pos: false, debug: false );
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

final dropdownProvider = NotifierProvider<DropDownController, AsyncValue<List<CoinBalance>>>(DropDownController.new);

class DropDownController extends Notifier<AsyncValue<List<CoinBalance>>> {
  final _entries = <CoinBalance>[];

  @override
  AsyncValue<List<CoinBalance>> build() {
    _entries.clear();
    return const AsyncLoading();
  }

  @override
  bool updateShouldNotify(
    AsyncValue<List<CoinBalance>> previous,
    AsyncValue<List<CoinBalance>> next,
  ) => !identical(previous, next);

  void getData() async {
    _entries.clear();
    List<CoinBalance> list = await BalanceCache.getAllRecords(forceRefresh: false);

    if (list.isNotEmpty) {
      _entries.addAll(list);
    }
    if (!ref.mounted) return;
    state = AsyncValue.data(_entries);
  }
}
