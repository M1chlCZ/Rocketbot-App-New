import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/NetInterface/interface.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/providers/network_provider.dart';

final coinsProvider = StateNotifierProvider<CoinsProvider, AsyncValue<PriceData>>((ref) {
  final net = ref.watch(networkProvider);
return CoinsProvider(net);
});

class CoinsProvider extends StateNotifier<AsyncValue<PriceData>> {
  NetInterface? netProvider;

  CoinsProvider(NetInterface net) : super(const AsyncLoading()) {
    netProvider = net;
  }
  void getData(int idCoin) async {
    final response = await netProvider!.get("Coin/GetPriceData?coinID=$idCoin&IncludeHistoryPrices=true&IncludeChange=true", debug: false);
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