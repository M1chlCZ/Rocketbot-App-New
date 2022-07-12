import 'package:rocketbot/models/coin.dart';

import 'Channel.dart';

/// message : "string"
/// hasError : true
/// error : "string"
/// data : [{"id":0,"member":true,"reward":0.0,"coin":{"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0.0,"blockchain":0,"minWithdraw":0.0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true},"channel":{"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-10T20:43:49.262Z"},"socialMedia":1,"createdAt":"2022-07-10T20:43:49.262Z"}]

class Airdrops {
  Airdrops({
      String? message, 
      bool? hasError, 
      String? error, 
      List<Airdrop>? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  Airdrops.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Airdrop.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _hasError;
  String? _error;
  List<Airdrop>? _data;
Airdrops copyWith({  String? message,
  bool? hasError,
  String? error,
  List<Airdrop>? data,
}) => Airdrops(  message: message ?? _message,
  hasError: hasError ?? _hasError,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  List<Airdrop>? get data => _data;

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

/// id : 0
/// member : true
/// reward : 0.0
/// coin : {"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0.0,"blockchain":0,"minWithdraw":0.0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true}
/// channel : {"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-10T20:43:49.262Z"}
/// socialMedia : 1
/// createdAt : "2022-07-10T20:43:49.262Z"

class Airdrop {
  Airdrop({
      int? id, 
      bool? member, 
      double? reward, 
      Coin? coin, 
      Channel? channel, 
      int? socialMedia, 
      String? createdAt,}){
    _id = id;
    _member = member;
    _reward = reward;
    _coin = coin;
    _channel = channel;
    _socialMedia = socialMedia;
    _createdAt = createdAt;
}

  Airdrop.fromJson(dynamic json) {
    _id = json['id'];
    _member = json['member'];
    _reward = json['reward'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _channel = json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    _socialMedia = json['socialMedia'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  bool? _member;
  double? _reward;
  Coin? _coin;
  Channel? _channel;
  int? _socialMedia;
  String? _createdAt;
Airdrop copyWith({  int? id,
  bool? member,
  double? reward,
  Coin? coin,
  Channel? channel,
  int? socialMedia,
  String? createdAt,
}) => Airdrop(  id: id ?? _id,
  member: member ?? _member,
  reward: reward ?? _reward,
  coin: coin ?? _coin,
  channel: channel ?? _channel,
  socialMedia: socialMedia ?? _socialMedia,
  createdAt: createdAt ?? _createdAt,
);
  int? get id => _id;
  bool? get member => _member;
  double? get reward => _reward;
  Coin? get coin => _coin;
  Channel? get channel => _channel;
  int? get socialMedia => _socialMedia;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['member'] = _member;
    map['reward'] = _reward;
    if (_coin != null) {
      map['coin'] = _coin?.toJson();
    }
    if (_channel != null) {
      map['channel'] = _channel?.toJson();
    }
    map['socialMedia'] = _socialMedia;
    map['createdAt'] = _createdAt;
    return map;
  }

}

