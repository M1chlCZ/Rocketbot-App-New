/// hasError : false
/// rewards : [{"hour":0,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":1,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":2,"amount":14,"day":"2022-07-14T00:00:00Z"},{"hour":3,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":4,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":5,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":7,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":8,"amount":21,"day":"2022-07-14T00:00:00Z"},{"hour":9,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":10,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":15,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":17,"amount":7,"day":"2022-07-14T00:00:00Z"},{"hour":18,"amount":21,"day":"2022-07-14T00:00:00Z"},{"hour":23,"amount":7,"day":"2022-07-13T00:00:00Z"}]
/// status : "OK"

class MasternodeData {
  MasternodeData({
      bool? hasError, 
      List<Rewards>? rewards, 
      String? status,}){
    _hasError = hasError;
    _rewards = rewards;
    _status = status;
}

  MasternodeData.fromJson(dynamic json) {
    _hasError = json['hasError'];
    if (json['rewards'] != null) {
      _rewards = [];
      json['rewards'].forEach((v) {
        _rewards?.add(Rewards.fromJson(v));
      });
    }
    _status = json['status'];
  }
  bool? _hasError;
  List<Rewards>? _rewards;
  String? _status;
MasternodeData copyWith({  bool? hasError,
  List<Rewards>? rewards,
  String? status,
}) => MasternodeData(  hasError: hasError ?? _hasError,
  rewards: rewards ?? _rewards,
  status: status ?? _status,
);
  bool? get hasError => _hasError;
  List<Rewards>? get rewards => _rewards;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasError'] = _hasError;
    if (_rewards != null) {
      map['rewards'] = _rewards?.map((v) => v.toJson()).toList();
    }
    map['status'] = _status;
    return map;
  }

}

/// hour : 0
/// amount : 7
/// day : "2022-07-14T00:00:00Z"

class Rewards {
  Rewards({
      int? hour, 
      double? amount,
      String? day,}){
    _hour = hour;
    _amount = amount;
    _day = day;
}

  Rewards.fromJson(dynamic json) {
    _hour = json['hour'];
    _amount = double.parse(json['amount'].toString());
    _day = json['day'];
  }
  int? _hour;
  double? _amount;
  String? _day;
Rewards copyWith({  int? hour,
  double? amount,
  String? day,
}) => Rewards(  hour: hour ?? _hour,
  amount: amount ?? _amount,
  day: day ?? _day,
);
  int? get hour => _hour;
  double? get amount => _amount;
  String? get day => _day;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hour'] = _hour;
    map['amount'] = _amount;
    map['day'] = _day;
    return map;
  }

}