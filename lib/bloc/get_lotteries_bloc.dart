import 'dart:async';

import 'package:rocketbot/endpoints/get_all_giveaways.dart';
import 'package:rocketbot/endpoints/get_all_lotteries.dart';
import 'package:rocketbot/models/giveaways.dart';
import 'package:rocketbot/models/loterries.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class LotteriesBloc {
  final LotteryList _coinBalances = LotteryList();

  BehaviorSubject<ApiResponse<List<Lottery>>>? _coinListController;

  StreamSink<ApiResponse<List<Lottery>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<Lottery>>> get coinsListStream =>
      _coinListController!.stream;

  LotteriesBloc({List<Lottery>? list}) {
    _coinListController = BehaviorSubject<ApiResponse<List<Lottery>>>();
    fetchGiveaways(list: list);
  }

  changeCoin ({List<Lottery>? list}) {
    fetchGiveaways(list: list);
  }

  Future <void> fetchGiveaways({List<Lottery>? list, bool force = false}) async {
    if (!_coinListController!.isClosed) {
      coinsListSink.add(ApiResponse.loading('Fetching Giveaways'));
    }
    try {
      List<Lottery>? coins;
      if(list == null ) {
        coins = await _coinBalances.fetchLotteries();
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