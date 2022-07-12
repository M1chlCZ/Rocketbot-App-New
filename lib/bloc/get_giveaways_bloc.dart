import 'dart:async';

import 'package:rocketbot/endpoints/get_all_giveaways.dart';
import 'package:rocketbot/models/giveaways.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class GiveawaysBloc {
  final GiveawaysList _coinBalances = GiveawaysList();

  BehaviorSubject<ApiResponse<List<Giveaway>>>? _coinListController;

  StreamSink<ApiResponse<List<Giveaway>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<Giveaway>>> get coinsListStream =>
      _coinListController!.stream;

  GiveawaysBloc({List<Giveaway>? list}) {
    _coinListController = BehaviorSubject<ApiResponse<List<Giveaway>>>();
    fetchGiveaways(list: list);
  }

  changeCoin ({List<Giveaway>? list}) {
    fetchGiveaways(list: list);
  }

  Future <void> fetchGiveaways({List<Giveaway>? list, bool force = false}) async {
    if (!_coinListController!.isClosed) {
      coinsListSink.add(ApiResponse.loading('Fetching Giveaways'));
    }
    try {
      List<Giveaway>? coins;
      if(list == null ) {
        coins = await _coinBalances.fetchGiveaways();
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