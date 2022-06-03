import 'package:rocketbot/models/pos_coins_list.dart';

import 'coin.dart';
import 'coin_graph.dart';

class BalanceList {
  BalanceList({
      String? message, 
      bool? hasError, 
      dynamic error, 
      List<CoinBalance>? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  BalanceList.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(CoinBalance.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _hasError;
  dynamic _error;
  List<CoinBalance>? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  dynamic get error => _error;
  List<CoinBalance>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['hasError'] = _hasError;
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CoinBalance {
  CoinBalance({
      int? userId, 
      Coin? coin,
    Coins? posCoin,
    PriceData? priceData,
    bool? staking,
      double? free,}){
    _userId = userId;
    _coin = coin;
    _free = free;
    _posCoin = posCoin;
    _staking = staking;
}

  CoinBalance.fromJson(dynamic json) {
    _userId = json['userId'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _free = double.parse(json['free'].toString());
  }
  int? _userId;
  Coin? _coin;
  double? _free;
  PriceData? _priceData;
  bool? _staking;
  Coins? _posCoin;

  int? get userId => _userId;
  Coin? get coin => _coin;
  double? get free => _free;
  PriceData? get priceData => _priceData;
  bool? get staking => _staking;
  Coins? get posCoin => _posCoin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    if (_coin != null) {
      map['coin'] = _coin?.toJson();
    }
    map['free'] = _free;
    return map;
  }

  void setPriceData(PriceData p) {
    _priceData = p;
  }

  void setStaking(bool b) {
    _staking = b;
  }
  void setPosCoin(Coins s) {
    _posCoin = s;
  }

}
