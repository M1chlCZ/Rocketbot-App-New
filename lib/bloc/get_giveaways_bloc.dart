import 'dart:async';

import 'package:rocketbot/endpoints/get_all_giveaways.dart';
import 'package:rocketbot/models/giveaways.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class GiveawaysBloc {
  final GiveawaysList _coinBalances = GiveawaysList();
  List<Giveaway>? coins;

  BehaviorSubject<ApiResponse<List<Giveaway>>>? _coinListController;

  StreamSink<ApiResponse<List<Giveaway>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<Giveaway>>> get coinsListStream =>
      _coinListController!.stream;

  GiveawaysBloc({List<Giveaway>? list}) {
    _coinListController = BehaviorSubject<ApiResponse<List<Giveaway>>>();
    fetchGiveaways();
  }

  Future <void> fetchGiveaways({int page = 1, bool force = false}) async {
    if (!_coinListController!.isClosed) {
      coinsListSink.add(ApiResponse.loading('Fetching Giveaways'));
    }
    try {
      if (coins != null && page != 1) {
        List<Giveaway>? s = await _coinBalances.fetchGiveaways(page);
        if (s != null) coins!.addAll(s);
      }else{
        coins = await _coinBalances.fetchGiveaways(page);
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