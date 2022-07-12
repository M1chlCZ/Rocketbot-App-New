import 'package:rocketbot/models/coin.dart';

/// message : "Successfully executed."
/// hasError : false
/// error : null
/// data : [{"id":0,"member":null,"reward":100.0,"membersLimit":50,"membersCount":8,"coin":{"id":33,"rank":18,"name":"Debt Free","ticker":"DTF","cryptoId":"DTF-BNB","isToken":true,"contractAddress":null,"feePercent":16.0,"blockchain":3,"minWithdraw":1.0,"bigImageId":"8337e906-dd2c-4c37-89ab-d1a401d0a119","smallImageId":"c04c5a4a-161b-4fde-9c13-2001871025e6","isActive":true,"explorerUrl":"https://bscscan.com/tx/{0}","requiredConfirmations":60,"fullName":"Debt Free [DTF] BEP20","tokenStandart":"BEP20","allowWithdraws":true,"allowDeposits":true},"channel":{"id":270,"rocketChannelId":"18446743072255128000","socialMedia":2,"name":"Crypto Reward","url":"https://t.me/bcgamereward","imageId":"d3f9db4d-d313-4abd-979f-0fdb88b8f944","followers":424,"updatedAt":"2022-07-08T15:50:09.5683577"},"socialMedia":2,"createdAt":"2022-07-09T08:45:25.3923467"}]

class Lotteries {
  Lotteries({
      String? message, 
      bool? hasError, 
      dynamic error, 
      List<Lottery>? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  Lotteries.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Lottery.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _hasError;
  dynamic _error;
  List<Lottery>? _data;
Lotteries copyWith({  String? message,
  bool? hasError,
  dynamic error,
  List<Lottery>? data,
}) => Lotteries(  message: message ?? _message,
  hasError: hasError ?? _hasError,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get hasError => _hasError;
  dynamic get error => _error;
  List<Lottery>? get data => _data;

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
/// member : null
/// reward : 100.0
/// membersLimit : 50
/// membersCount : 8
/// coin : {"id":33,"rank":18,"name":"Debt Free","ticker":"DTF","cryptoId":"DTF-BNB","isToken":true,"contractAddress":null,"feePercent":16.0,"blockchain":3,"minWithdraw":1.0,"bigImageId":"8337e906-dd2c-4c37-89ab-d1a401d0a119","smallImageId":"c04c5a4a-161b-4fde-9c13-2001871025e6","isActive":true,"explorerUrl":"https://bscscan.com/tx/{0}","requiredConfirmations":60,"fullName":"Debt Free [DTF] BEP20","tokenStandart":"BEP20","allowWithdraws":true,"allowDeposits":true}
/// channel : {"id":270,"rocketChannelId":"18446743072255128000","socialMedia":2,"name":"Crypto Reward","url":"https://t.me/bcgamereward","imageId":"d3f9db4d-d313-4abd-979f-0fdb88b8f944","followers":424,"updatedAt":"2022-07-08T15:50:09.5683577"}
/// socialMedia : 2
/// createdAt : "2022-07-09T08:45:25.3923467"

class Lottery {
  Lottery({
      int? id, 
      dynamic member, 
      double? reward, 
      int? membersLimit, 
      int? membersCount, 
      Coin? coin, 
      Channel? channel, 
      int? socialMedia, 
      String? createdAt,}){
    _id = id;
    _member = member;
    _reward = reward;
    _membersLimit = membersLimit;
    _membersCount = membersCount;
    _coin = coin;
    _channel = channel;
    _socialMedia = socialMedia;
    _createdAt = createdAt;
}

  Lottery.fromJson(dynamic json) {
    _id = json['id'];
    _member = json['member'];
    _reward = json['reward'];
    _membersLimit = json['membersLimit'];
    _membersCount = json['membersCount'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _channel = json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    _socialMedia = json['socialMedia'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  dynamic _member;
  double? _reward;
  int? _membersLimit;
  int? _membersCount;
  Coin? _coin;
  Channel? _channel;
  int? _socialMedia;
  String? _createdAt;
Lottery copyWith({  int? id,
  dynamic member,
  double? reward,
  int? membersLimit,
  int? membersCount,
  Coin? coin,
  Channel? channel,
  int? socialMedia,
  String? createdAt,
}) => Lottery(  id: id ?? _id,
  member: member ?? _member,
  reward: reward ?? _reward,
  membersLimit: membersLimit ?? _membersLimit,
  membersCount: membersCount ?? _membersCount,
  coin: coin ?? _coin,
  channel: channel ?? _channel,
  socialMedia: socialMedia ?? _socialMedia,
  createdAt: createdAt ?? _createdAt,
);
  int? get id => _id;
  dynamic get member => _member;
  double? get reward => _reward;
  int? get membersLimit => _membersLimit;
  int? get membersCount => _membersCount;
  Coin? get coin => _coin;
  Channel? get channel => _channel;
  int? get socialMedia => _socialMedia;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['member'] = _member;
    map['reward'] = _reward;
    map['membersLimit'] = _membersLimit;
    map['membersCount'] = _membersCount;
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

/// id : 270
/// rocketChannelId : "18446743072255128000"
/// socialMedia : 2
/// name : "Crypto Reward"
/// url : "https://t.me/bcgamereward"
/// imageId : "d3f9db4d-d313-4abd-979f-0fdb88b8f944"
/// followers : 424
/// updatedAt : "2022-07-08T15:50:09.5683577"

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