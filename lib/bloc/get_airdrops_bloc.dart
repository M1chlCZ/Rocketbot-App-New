import 'dart:async';

import 'package:rocketbot/endpoints/get_all_airdrops.dart';
import 'package:rocketbot/models/airdrops.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class AirdropsBloc {
  final AirdropList _coinBalances = AirdropList();
  List<Airdrop>? coins;
  BehaviorSubject<ApiResponse<List<Airdrop>>>? _coinListController;

  StreamSink<ApiResponse<List<Airdrop>>> get coinsListSink => _coinListController!.sink;

  Stream<ApiResponse<List<Airdrop>>> get coinsListStream => _coinListController!.stream;

  AirdropsBloc({List<Airdrop>? list}) {
    _coinListController = BehaviorSubject<ApiResponse<List<Airdrop>>>();
    fetchGiveaways();
  }

  Future<void> fetchGiveaways({int page = 1, bool force = false}) async {
    try {
      if (coins != null && page != 1) {
        if (!_coinListController!.isClosed) {
          coinsListSink.add(ApiResponse.loading('Fetching Giveaways'));
        }
        List<Airdrop>? s = await _coinBalances.fetchAirdrops(page);
        if (s != null) coins!.addAll(s);
      } else if (coins != null) {
        coins = await _coinBalances.fetchAirdrops(page);
      } else {
        if (!_coinListController!.isClosed) {
          coinsListSink.add(ApiResponse.loading('Fetching Giveaways'));
        }
        coins = await _coinBalances.fetchAirdrops(page);
      }
      if (!_coinListController!.isClosed) {
        coinsListSink.add(ApiResponse.completed(coins));
      }
    } catch (e) {
      if (!_coinListController!.isClosed) {
        coinsListSink.add(ApiResponse.error(e.toString()));
      }
      // print(e);
    }
  }

  dispose() {
    _coinListController?.close();
  }
}
