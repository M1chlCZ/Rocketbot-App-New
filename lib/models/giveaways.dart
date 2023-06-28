import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/ordinals.dart';

/// message : "string"
/// hasError : true
/// error : "string"
/// data : [{"id":0,"member":true,"reward":0,"coin":{"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0,"blockchain":0,"minWithdraw":0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true},"channel":{"id":0,"rocketChannelId":0,"socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-08T23:16:47.689Z"},"socialMedia":1,"createdAt":"2022-07-08T23:16:47.689Z"}]

class Giveaways {
  Giveaways({
      String? message, 
      bool? hasError, 
      String? error, 
      List<Giveaway>? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  Giveaways.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Giveaway.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _hasError;
  String? _error;
  List<Giveaway>? _data;
Giveaways copyWith({  String? message,
  bool? hasError,
  String? error,
  List<Giveaway>? data,
}) => Giveaways(  message: message ?? _message,
  hasError: hasError ?? _hasError,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  List<Giveaway>? get data => _data;

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
/// reward : 0
/// coin : {"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0,"blockchain":0,"minWithdraw":0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true}
/// channel : {"id":0,"rocketChannelId":0,"socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-08T23:16:47.689Z"}
/// socialMedia : 1
/// createdAt : "2022-07-08T23:16:47.689Z"

class Giveaway {
  Giveaway({
      int? id, 
      bool? member, 
      double? reward,
      Coin? coin,
    Ordinal? ordinal,
      Channel? channel, 
      int? socialMedia, 
      String? createdAt,}){
    _id = id;
    _member = member;
    _reward = reward;
    _coin = coin;
    _ordinal = ordinal;
    _channel = channel;
    _socialMedia = socialMedia;
    _createdAt = createdAt;
}

  Giveaway.fromJson(dynamic json) {
    _id = json['id'];
    _member = json['member'];
    _reward = json['reward'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _ordinal = json['ordinal'] != null ? Ordinal.fromJson(json['ordinal']) : null;
    _channel = json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    _socialMedia = json['socialMedia'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  bool? _member;
  double? _reward;
  Coin? _coin;
  Ordinal? _ordinal;
  Channel? _channel;
  int? _socialMedia;
  String? _createdAt;
Giveaway copyWith({  int? id,
  bool? member,
  double? reward,
  Coin? coin,
  Ordinal? ordinal,
  Channel? channel,
  int? socialMedia,
  String? createdAt,
}) => Giveaway(  id: id ?? _id,
  member: member ?? _member,
  reward: reward ?? _reward,
  coin: coin ?? _coin,
  ordinal: ordinal ?? _ordinal,
  channel: channel ?? _channel,
  socialMedia: socialMedia ?? _socialMedia,
  createdAt: createdAt ?? _createdAt,
);
  int? get id => _id;
  bool? get member => _member;
  double? get reward => _reward;
  Coin? get coin => _coin;
  Ordinal? get ordinal => _ordinal;
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
    if (_ordinal != null) {
      map['ordinal'] = _ordinal?.toJson();
    }
    if (_channel != null) {
      map['channel'] = _channel?.toJson();
    }
    map['socialMedia'] = _socialMedia;
    map['createdAt'] = _createdAt;
    return map;
  }

}

/// id : 0
/// rocketChannelId : 0
/// socialMedia : 1
/// name : "string"
/// url : "string"
/// imageId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// followers : 0
/// updatedAt : "2022-07-08T23:16:47.689Z"

class Channel {
  Channel({
      int? id, 
      String? rocketChannelId,
      int? socialMedia, 
      String? name, 
      String? url, 
      String? imageId, 
      int? followers, 
      String? updatedAt,}){
    _id = id;
    _rocketChannelId = rocketChannelId;
    _socialMedia = socialMedia;
    _name = name;
    _url = url;
    _imageId = imageId;
    _followers = followers;
    _updatedAt = updatedAt;
}

  Channel.fromJson(dynamic json) {
    _id = json['id'];
    _rocketChannelId = json['rocketChannelId'].toString();
    _socialMedia = json['socialMedia'];
    _name = json['name'];
    _url = json['url'];
    _imageId = json['imageId'];
    _followers = json['followers'];
    _updatedAt = json['updatedAt'];
  }
  int? _id;
  String? _rocketChannelId;
  int? _socialMedia;
  String? _name;
  String? _url;
  String? _imageId;
  int? _followers;
  String? _updatedAt;
Channel copyWith({  int? id,
  String? rocketChannelId,
  int? socialMedia,
  String? name,
  String? url,
  String? imageId,
  int? followers,
  String? updatedAt,
}) => Channel(  id: id ?? _id,
  rocketChannelId: rocketChannelId ?? _rocketChannelId,
  socialMedia: socialMedia ?? _socialMedia,
  name: name ?? _name,
  url: url ?? _url,
  imageId: imageId ?? _imageId,
  followers: followers ?? _followers,
  updatedAt: updatedAt ?? _updatedAt,
);
  int? get id => _id;
  String? get rocketChannelId => _rocketChannelId;
  int? get socialMedia => _socialMedia;
  String? get name => _name;
  String? get url => _url;
  String? get imageId => _imageId;
  int? get followers => _followers;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['rocketChannelId'] = _rocketChannelId;
    map['socialMedia'] = _socialMedia;
    map['name'] = _name;
    map['url'] = _url;
    map['imageId'] = _imageId;
    map['followers'] = _followers;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}
