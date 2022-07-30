import 'dart:async';

import 'package:rocketbot/endpoints/get_detail_airdrop.dart';
import 'package:rocketbot/endpoints/get_detail_giveaway.dart';
import 'package:rocketbot/endpoints/get_detail_lottery.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class LotteryDetailBloc {
  final LotteryDetail _coinBalances = LotteryDetail();

  BehaviorSubject<ApiResponse<Map<String, dynamic>>>? _coinListController;

  StreamSink<ApiResponse<Map<String, dynamic>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<Map<String, dynamic>>> get coinsListStream =>
      _coinListController!.stream;

  LotteryDetailBloc(int id) {
    _coinListController = BehaviorSubject<ApiResponse<Map<String, dynamic>>>();
    fetchDetail(id);
  }


  Future <void> fetchDetail(int id, {bool force = false}) async {
    if (!_coinListController!.isClosed) {
      coinsListSink.add(ApiResponse.loading('Fetching Giveaway'));
    }
    try {
      Map<String, dynamic>? mp = await _coinBalances.fetchLottery(id);
      if (!_coinListController!.isClosed) {
        coinsListSink.add(ApiResponse.completed(mp));
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