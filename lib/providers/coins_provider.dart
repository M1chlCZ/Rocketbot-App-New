import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/providers/network_provider.dart';

final coinsProvider = NotifierProvider<CoinsProvider, AsyncValue<PriceData>>(
  CoinsProvider.new,
);

class CoinsProvider extends Notifier<AsyncValue<PriceData>> {
  late RocketbotClient _net;

  @override
  AsyncValue<PriceData> build() {
    _net = ref.watch(networkProvider);
    return const AsyncLoading();
  }
  void getData(int idCoin) async {
    final response = await _net.get("Coin/GetPriceData?coinID=$idCoin&IncludeHistoryPrices=true&IncludeChange=true", debug: false);
    if (!ref.mounted) return;
    final data = CoinGraph.fromJson(response,idCoin.toString()).data;
    if (data == null) {
      state = AsyncValue.error("Error", StackTrace.current);
      return;
    }
    state = AsyncValue.data(data);
  }
  void changeCoin (int coinID) {
    getData(coinID);
  }
}