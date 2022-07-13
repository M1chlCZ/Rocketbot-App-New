class PosCoinsList {
  PosCoinsList({
    List<Coins>? coins,
    List<int>? coinsMn,
    bool? hasError,
    String? status,}){
    _coins = coins;
    _coinsMn = coinsMn;
    _hasError = hasError;
    _status = status;
  }

  PosCoinsList.fromJson(dynamic json) {
    if (json['coins'] != null) {
      _coins = [];
      json['coins'].forEach((v) {
        _coins?.add(Coins.fromJson(v));
      });
    }
    _coinsMn = json['coins_mn'] != null ? json['coins_mn'].cast<int>() : [];
    _hasError = json['hasError'];
    _status = json['status'];
  }
  List<Coins>? _coins;
  List<int>? _coinsMn;
  bool? _hasError;
  String? _status;
  PosCoinsList copyWith({  List<Coins>? coins,
    List<int>? coinsMn,
    bool? hasError,
    String? status,
  }) => PosCoinsList(  coins: coins ?? _coins,
    coinsMn: coinsMn ?? _coinsMn,
    hasError: hasError ?? _hasError,
    status: status ?? _status,
  );
  List<Coins>? get coins => _coins;
  List<int>? get coinsMn => _coinsMn;
  bool? get hasError => _hasError;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_coins != null) {
      map['coins'] = _coins?.map((v) => v.toJson()).toList();
    }
    map['coins_mn'] = _coinsMn;
    map['hasError'] = _hasError;
    map['status'] = _status;
    return map;
  }

}

/// idCoin : 2222222
/// depositAddr : "MTQ26uK1TH3Y3MjULwQYnqZzJ8BWzF2SRv"
/// amount : 0

class Coins {
  Coins({
    int? idCoin,
    String? depositAddr,
    double? amount,}){
    _idCoin = idCoin;
    _depositAddr = depositAddr;
    _amount = amount;
  }

  Coins.fromJson(dynamic json) {
    _idCoin = json['idCoin'];
    _depositAddr = json['depositAddr'];
    _amount = double.parse(json['amount'].toString());
  }
  int? _idCoin;
  String? _depositAddr;
  double? _amount;
  Coins copyWith({  int? idCoin,
    String? depositAddr,
    double? amount,
  }) => Coins(  idCoin: idCoin ?? _idCoin,
    depositAddr: depositAddr ?? _depositAddr,
    amount: amount ?? _amount,
  );
  int? get idCoin => _idCoin;
  String? get depositAddr => _depositAddr;
  double? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idCoin'] = _idCoin;
    map['depositAddr'] = _depositAddr;
    map['amount'] = _amount;
    return map;
  }

}