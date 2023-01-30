import 'dart:async';

import 'package:rocketbot/endpoints/get_detail_airdrop.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class AirdropDetailBloc {
  final AirdropDetail _coinBalances = AirdropDetail();

  BehaviorSubject<ApiResponse<Map<String, dynamic>>>? _coinListController;

  StreamSink<ApiResponse<Map<String, dynamic>>> get coinsListSink => _coinListController!.sink;

  Stream<ApiResponse<Map<String, dynamic>>> get coinsListStream => _coinListController!.stream;

  AirdropDetailBloc(int id) {
    _coinListController = BehaviorSubject<ApiResponse<Map<String, dynamic>>>();
    fetchDetail(id);
  }

  Future<void> fetchDetail(int id, {bool force = false}) async {
    if (!_coinListController!.isClosed) {
      coinsListSink.add(ApiResponse.loading('Fetching Giveaway'));
    }
    try {
      Map<String, dynamic>? mp = await _coinBalances.fetchAirdrop(id);
      if (!_coinListController!.isClosed) {
        coinsListSink.add(ApiResponse.completed(mp));
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
