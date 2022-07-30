import 'dart:async';

import 'package:rocketbot/endpoints/get_all_lotteries.dart';
import 'package:rocketbot/models/loterries.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class LotteriesBloc {
  final LotteryList _coinBalances = LotteryList();
  List<Lottery>? coins;
  BehaviorSubject<ApiResponse<List<Lottery>>>? _coinListController;

  StreamSink<ApiResponse<List<Lottery>>> get coinsListSink => _coinListController!.sink;

  Stream<ApiResponse<List<Lottery>>> get coinsListStream => _coinListController!.stream;

  LotteriesBloc({List<Lottery>? list}) {
    _coinListController = BehaviorSubject<ApiResponse<List<Lottery>>>();
    fetchGiveaways();
  }

  Future<void> fetchGiveaways({int page = 1, bool force = false}) async {
    try {
      if (coins != null && page != 1) {
        if (!_coinListController!.isClosed) {
          coinsListSink.add(ApiResponse.loading('Fetching Giveaways'));
        }
        List<Lottery>? s = await _coinBalances.fetchLotteries(page);
        if (s != null) coins!.addAll(s);
      } else if (coins != null) {
        coins = await _coinBalances.fetchLotteries(page);
      } else {
        if (!_coinListController!.isClosed) {
          coinsListSink.add(ApiResponse.loading('Fetching Giveaways'));
        }
        coins = await _coinBalances.fetchLotteries(page);
      }
      if (!_coinListController!.isClosed) {
        coinsListSink.add(ApiResponse.completed(coins));
      }
    } catch (e) {
      print(e);
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
