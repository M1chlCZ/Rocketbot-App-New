import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/netinterface/interface.dart';

class CoinPrices {
  final RocketbotClient _helper = RocketbotClient();

  Future<PriceData?> fetchCoinPrice(String coin, int coinID) async {
    final response = await _helper.get("Coin/GetPriceData?coinID=$coinID&IncludeHistoryPrices=true&IncludeChange=true");
    return CoinGraph.fromJson(response,coinID.toString()).data;
  }
}