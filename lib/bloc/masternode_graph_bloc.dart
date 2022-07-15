import 'dart:async';

import 'package:rocketbot/endpoints/get_masternode_graph.dart';
import 'package:rocketbot/endpoints/get_stake_graph.dart';
import 'package:rocketbot/models/masternode_data.dart';
import 'package:rocketbot/models/stake_data.dart';
import 'package:rocketbot/netInterface/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasternodeGraphBloc {
  final MasternodeList _coinsList = MasternodeList();

  StreamController<ApiResponse<MasternodeData>>? _coinListController;

  StreamSink<ApiResponse<MasternodeData>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<MasternodeData>> get coinsListStream =>
      _coinListController!.stream;

  stakeBloc() {
    _coinListController = BehaviorSubject<ApiResponse<MasternodeData>>();
  }

  fetchStakeData(int coinID, int type) async {
    coinsListSink.add(ApiResponse.loading('Fetching All Stakes'));
    try {
      MasternodeData? coins = await _coinsList.getStakingData(coinID, type);
      coinsListSink.add(ApiResponse.completed(coins));
    } catch (e) {
      coinsListSink.add(ApiResponse.error(e.toString()));
      //
    }
  }

  dispose() {
    _coinListController?.close();
  }
}