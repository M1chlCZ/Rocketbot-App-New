/// active : 1
/// amount : 0.2
/// hasError : false
/// stakesAmount : 2777.999999999944
/// status : "OK"

class StakeCheck {
  StakeCheck({
    int? active,
    double? amount,
    bool? hasError,
    double? stakesAmount,
    double? uncofirmed,
    double? contribution,
    double? inPoolTotal,
    double? estimated,
    String? status,}){
    _active = active;
    _amount = amount;
    _hasError = hasError;
    _stakesAmount = stakesAmount;
    _status = status;
    _contribution = contribution;
    _estimated = estimated;
    _inPoolTotal = inPoolTotal;
  }

  StakeCheck.fromJson(dynamic json) {
    _active = json['active'];
    _amount = double.parse(json['amount'].toString());
    _hasError = json['hasError'];
    _stakesAmount = double.parse(json['stakesAmount'].toString());
    _status = json['status'];
    _unconfirmed = double.parse(json['uncofirmedAmount'].toString());
    _contribution = double.parse(json['contribution'].toString());
    _inPoolTotal = double.parse(json['poolAmount'].toString());
    _estimated = double.parse(json['estimated'].toString());
  }
  int? _active;
  double? _amount;
  bool? _hasError;
  double? _stakesAmount;
  String? _status;
  double? _unconfirmed;
  double? _contribution;
  double? _inPoolTotal;
  double? _estimated;

  int? get active => _active;
  double? get amount => _amount;
  bool? get hasError => _hasError;
  double? get stakesAmount => _stakesAmount;
  String? get status => _status;
  double? get unconfirmed => _unconfirmed;
  double? get contribution => _contribution;
  double? get inPoolTotal => _inPoolTotal;
  double? get estimated => _estimated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['active'] = _active;
    map['amount'] = _amount;
    map['hasError'] = _hasError;
    map['stakesAmount'] = _stakesAmount;
    map['status'] = _status;
    map['contribution'] = contribution;
    map['poolAmount'] = inPoolTotal;
    map['estimated'] = estimated;
    return map;
  }

}