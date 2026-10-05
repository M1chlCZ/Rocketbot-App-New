import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/endpoints/get_transactions.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/transaction_data.dart';

final transactionProvider = NotifierProvider<TransactionProvider, AsyncValue<List<TransactionData>?>>(TransactionProvider.new);

class TransactionProvider extends Notifier<AsyncValue<List<TransactionData>?>> {
  List<TransactionData>? coins;
  final TransactionList _coinBalances = TransactionList();

  @override
  AsyncValue<List<TransactionData>?> build() {
    coins = null;
    return const AsyncLoading();
  }

  @override
  bool updateShouldNotify(
    AsyncValue<List<TransactionData>?> previous,
    AsyncValue<List<TransactionData>?> next,
  ) => !identical(previous, next);

  void fetchTransactionData(Coin coin, {List<TransactionData>? list, bool force = false}) async {
    try {
      if(list == null ) {
        coins = await _coinBalances.fetchTransactions(
            coin.id!, force);
      }else{
        coins = list;
      }
      if (!ref.mounted) return;
      state = AsyncValue.data(coins);
      }catch (e, st) {
        if (!ref.mounted) return;
        state = AsyncValue.error(e, st);
      }
  }

  void changeCoin (Coin coin, {List<TransactionData>? list}) {
    fetchTransactionData(coin,list: list);
  }
}