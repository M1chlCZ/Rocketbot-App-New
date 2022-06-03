import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rocketbot/endpoints/get_all_balances.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rocketbot/support/globals.dart' as globals;
import 'package:rocketbot/support/secure_storage.dart';

class BalancesBloc {
  final CoinBalances _balanceList = CoinBalances();
  List<CoinBalance>? _coins;
  List<CoinBalance>? _sortedCoins;
  int _sort = 0;


  StreamController<ApiResponse<List<CoinBalance>>>? _coinListController;

  StreamSink<ApiResponse<List<CoinBalance>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<CoinBalance>>> get coinsListStream =>
      _coinListController!.stream;

  BalancesBloc() {
    _coinListController = StreamController<ApiResponse<List<CoinBalance>>>();
    fetchBalancesList();
  }

  showWait() async {
    coinsListSink.add(ApiResponse.loading('Fetching All Coins'));
  }

  fetchBalancesList({int? sort, bool refresh = false}) async {
    coinsListSink.add(ApiResponse.loading('Fetching All Coins'));
    try {
      if (sort == null) {
        var i = await SecureStorage.readStorage(key: globals.SORT_TYPE);
        if (i != null) {
          _sort = int.parse(i);
        } else {
          _sort = 0;
        }
      } else {
        _sort = sort;
      }
      if (!_coinListController!.isClosed) {
        if (refresh) _coins = null;

        coinsListSink.add(ApiResponse.loading('Fetching All Coins'));
        // print("1 |" + DateTime.now().toString());
        _coins ??= await _balanceList.fetchAllBalances(refresh);
        // print("2 |" + DateTime.now().toString());
        _sortedCoins = await _sortList(_coins, sort: _sort);
        // print("3 |" + DateTime.now().toString());
        coinsListSink.add(ApiResponse.completed(_sortedCoins));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (!_coinListController!.isClosed) {
        coinsListSink.add(ApiResponse.error(e.toString()));
      }
      // print(e);
    }
  }

  filterCoinsList({bool zero = true, sort = 0}) async {
    try {
      coinsListSink.add(ApiResponse.loading('Filtering All Coins'));
      List<CoinBalance>? filterList = [];

        for (var market in _sortedCoins!) {
          if (market.free! != 0.0) {
            filterList.add(market);
          }
        }

      if (!_coinListController!.isClosed) {

        coinsListSink.add(ApiResponse.completed(filterList));
      }
    } catch (e) {
      coinsListSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  Future<List<CoinBalance>> _sortList(List<CoinBalance>? finalList, {int sort = 0}) async {
    if (sort == 0) {
      finalList!.sort((a, b) {
        int A = a.coin!.rank!;
        int B = b.coin!.rank!;
        return A.compareTo(B);
      });
    } else if (sort == 1) {
      finalList!.sort((a, b) {
        var A = a.coin!.cryptoId;
        var B = b.coin!.cryptoId;
        return A.toString().toLowerCase().compareTo(B.toString().toLowerCase());
      });
    } else if (sort == 2) {
      finalList!.sort((a, b) {
        double A = a.free!;
        double B = b.free!;
        return B.compareTo(A);
      });
    } else if (sort == 3) {
      finalList!.sort((a, b) {
        double A = a.free! * a.priceData!.prices!.usd!.toDouble();
        double B = b.free! * b.priceData!.prices!.usd!.toDouble();
        return B.compareTo(A);
      });
    }
    return finalList!;
  }

  dispose() {
    _coinListController?.close();
  }
}
