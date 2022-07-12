import 'dart:async';

import 'package:rocketbot/endpoints/get_all_airdrops.dart';
import 'package:rocketbot/models/airdrops.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class AirdropsBloc {
  final AirdropList _coinBalances = AirdropList();

  BehaviorSubject<ApiResponse<List<Airdrop>>>? _coinListController;

  StreamSink<ApiResponse<List<Airdrop>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<Airdrop>>> get coinsListStream =>
      _coinListController!.stream;

  AirdropsBloc({List<Airdrop>? list}) {
    _coinListController = BehaviorSubject<ApiResponse<List<Airdrop>>>();
    fetchGiveaways(list: list);
  }

  changeCoin ({List<Airdrop>? list}) {
    fetchGiveaways(list: list);
  }

  Future <void> fetchGiveaways({List<Airdrop>? list, bool force = false}) async {
    if (!_coinListController!.isClosed) {
      coinsListSink.add(ApiResponse.loading('Fetching Giveaways'));
    }
    try {
      List<Airdrop>? coins;
      if(list == null ) {
        coins = await _coinBalances.fetchAirdrops();
      }else{
        coins = list;
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