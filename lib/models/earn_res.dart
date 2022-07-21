/// earnings : [{"idCoin":2,"amount":3257.7944},{"idCoin":6,"amount":0.009312665}]
/// hasError : false
/// status : "OK"

class EarnRes {
  EarnRes({
      List<Earnings>? earnings, 
      bool? hasError, 
      String? status,}){
    _earnings = earnings;
    _hasError = hasError;
    _status = status;
}

  EarnRes.fromJson(dynamic json) {
    if (json['earnings'] != null) {
      _earnings = [];
      json['earnings'].forEach((v) {
        _earnings?.add(Earnings.fromJson(v));
      });
    }
    _hasError = json['hasError'];
    _status = json['status'];
  }
  List<Earnings>? _earnings;
  bool? _hasError;
  String? _status;
EarnRes copyWith({  List<Earnings>? earnings,
  bool? hasError,
  String? status,
}) => EarnRes(  earnings: earnings ?? _earnings,
  hasError: hasError ?? _hasError,
  status: status ?? _status,
);
  List<Earnings>? get earnings => _earnings;
  bool? get hasError => _hasError;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_earnings != null) {
      map['earnings'] = _earnings?.map((v) => v.toJson()).toList();
    }
    map['hasError'] = _hasError;
    map['status'] = _status;
    return map;
  }

}

/// idCoin : 2
/// amount : 3257.7944

class Earnings {
  Earnings({
      int? idCoin, 
      double? amount,}){
    _idCoin = idCoin;
    _amount = amount;
}

  Earnings.fromJson(dynamic json) {
    _idCoin = json['idCoin'];
    _amount = json['amount'];
  }
  int? _idCoin;
  double? _amount;
Earnings copyWith({  int? idCoin,
  double? amount,
}) => Earnings(  idCoin: idCoin ?? _idCoin,
  amount: amount ?? _amount,
);
  int? get idCoin => _idCoin;
  double? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idCoin'] = _idCoin;
    map['amount'] = _amount;
    return map;
  }

}