import 'dart:async';

import 'package:rocketbot/endpoints/get_detail_giveaway.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class GiveawayDetailBloc {
  final GiveawayDetail _coinBalances = GiveawayDetail();

  BehaviorSubject<ApiResponse<Map<String, dynamic>>>? _coinListController;

  StreamSink<ApiResponse<Map<String, dynamic>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<Map<String, dynamic>>> get coinsListStream =>
      _coinListController!.stream;

  GiveawayDetailBloc(int id, int socialNetwork,) {
    _coinListController = BehaviorSubject<ApiResponse<Map<String, dynamic>>>();
    fetchDetail(id, socialNetwork);
  }


  Future <void> fetchDetail(int id, int socialNetwork, {bool force = false}) async {
    if (!_coinListController!.isClosed) {
      coinsListSink.add(ApiResponse.loading('Fetching Giveaway'));
    }
    try {
      Map<String, dynamic>? mp = await _coinBalances.fetchGiveaways(id, socialNetwork);
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