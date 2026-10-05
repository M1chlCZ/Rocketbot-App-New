import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/endpoints/get_transactions.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/transaction_data.dart';
import 'package:rocketbot/providers/network_provider.dart';

final transactionProvider = StateNotifierProvider<TransactionProvider, AsyncValue<List<TransactionData>?>>((ref) {
  final net = ref.watch(networkProvider);
  return TransactionProvider(net);
});

class TransactionProvider extends StateNotifier<AsyncValue<List<TransactionData>?>> {
  RocketbotClient? netProvider;
  List<TransactionData>? coins;
  final TransactionList _coinBalances = TransactionList();

  TransactionProvider(RocketbotClient net) : super(const AsyncLoading()) {
    netProvider = net;
  }
  void fetchTransactionData(Coin coin, {List<TransactionData>? list, bool force = false}) async {
    try {
      if(list == null ) {
        coins = await _coinBalances.fetchTransactions(
            coin.id!, force);
      }else{
        coins = list;
      }
      state = AsyncValue.data(coins);
      }catch (e, st) {
        state = AsyncValue.error(e, st);
      }
  }

  void changeCoin (Coin coin, {List<TransactionData>? list}) {
    fetchTransactionData(coin,list: list);
  }
}