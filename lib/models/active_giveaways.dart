import 'package:rocketbot/models/coin.dart';

import 'Channel.dart';
import 'Creator.dart';

/// message : "string"
/// hasError : true
/// error : "string"
/// data : {"id":0,"isActive":true,"isCanceled":true,"isWinnersAwarded":true,"reward":0,"rocketChannelId":"0","winnersLimit":0,"membersCount":0,"winnersCount":0,"coin":{"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0.0,"blockchain":0,"minWithdraw":0.0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true},"channel":{"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-10T23:02:54.604Z"},"creator":{"id":0,"userId":0,"rocketAccountId":0,"name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-10T23:02:54.604Z","updatedAt":"2022-07-10T23:02:54.604Z","mention":"string"},"winners":[{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-10T23:02:54.604Z","updatedAt":"2022-07-10T23:02:54.604Z","mention":"string"}],"socialMedia":1,"createdAt":"2022-07-10T23:02:54.604Z","finishedAt":"2022-07-10T23:02:54.604Z","expirationTime":"2022-07-10T23:02:54.604Z"}

class ActiveGiveaways {
  ActiveGiveaways({
      String? message, 
      bool? hasError, 
      String? error, 
      ActiveGiveaway? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  ActiveGiveaways.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'] != null ? ActiveGiveaway.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _hasError;
  String? _error;
  ActiveGiveaway? _data;
ActiveGiveaways copyWith({  String? message,
  bool? hasError,
  String? error,
  ActiveGiveaway? data,
}) => ActiveGiveaways(  message: message ?? _message,
  hasError: hasError ?? _hasError,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  ActiveGiveaway? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['hasError'] = _hasError;
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// id : 0
/// isActive : true
/// isCanceled : true
/// isWinnersAwarded : true
/// reward : 0
/// rocketChannelId : "0"
/// winnersLimit : 0
/// membersCount : 0
/// winnersCount : 0
/// coin : {"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0.0,"blockchain":0,"minWithdraw":0.0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true}
/// channel : {"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-10T23:02:54.604Z"}
/// creator : {"id":0,"userId":0,"rocketAccountId":0,"name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-10T23:02:54.604Z","updatedAt":"2022-07-10T23:02:54.604Z","mention":"string"}
/// winners : [{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-10T23:02:54.604Z","updatedAt":"2022-07-10T23:02:54.604Z","mention":"string"}]
/// socialMedia : 1
/// createdAt : "2022-07-10T23:02:54.604Z"
/// finishedAt : "2022-07-10T23:02:54.604Z"
/// expirationTime : "2022-07-10T23:02:54.604Z"

class ActiveGiveaway {
  ActiveGiveaway({
      int? id, 
      bool? isActive, 
      bool? isCanceled, 
      bool? isWinnersAwarded, 
      double? reward,
      String? rocketChannelId, 
      int? winnersLimit, 
      int? membersCount, 
      int? winnersCount, 
      Coin? coin, 
      Channel? channel, 
      Creator? creator, 
      List<Winners>? winners, 
      int? socialMedia, 
      String? createdAt, 
      String? finishedAt, 
      String? expirationTime,}){
    _id = id;
    _isActive = isActive;
    _isCanceled = isCanceled;
    _isWinnersAwarded = isWinnersAwarded;
    _reward = reward;
    _rocketChannelId = rocketChannelId;
    _winnersLimit = winnersLimit;
    _membersCount = membersCount;
    _winnersCount = winnersCount;
    _coin = coin;
    _channel = channel;
    _creator = creator;
    _winners = winners;
    _socialMedia = socialMedia;
    _createdAt = createdAt;
    _finishedAt = finishedAt;
    _expirationTime = expirationTime;
}

  ActiveGiveaway.fromJson(dynamic json) {
    _id = json['id'];
    _isActive = json['isActive'];
    _isCanceled = json['isCanceled'];
    _isWinnersAwarded = json['isWinnersAwarded'];
    _reward = double.parse(json['reward'].toString());
    _rocketChannelId = json['rocketChannelId'].toString();
    _winnersLimit = json['winnersLimit'];
    _membersCount = json['membersCount'];
    _winnersCount = json['winnersCount'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _channel = json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    _creator = json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    if (json['winners'] != null) {
      _winners = [];
      json['winners'].forEach((v) {
        _winners?.add(Winners.fromJson(v));
      });
    }
    _socialMedia = json['socialMedia'];
    _createdAt = json['createdAt'];
    _finishedAt = json['finishedAt'];
    _expirationTime = json['expirationTime'];
  }
  int? _id;
  bool? _isActive;
  bool? _isCanceled;
  bool? _isWinnersAwarded;
  double? _reward;
  String? _rocketChannelId;
  int? _winnersLimit;
  int? _membersCount;
  int? _winnersCount;
  Coin? _coin;
  Channel? _channel;
  Creator? _creator;
  List<Winners>? _winners;
  int? _socialMedia;
  String? _createdAt;
  String? _finishedAt;
  String? _expirationTime;
ActiveGiveaway copyWith({  int? id,
  bool? isActive,
  bool? isCanceled,
  bool? isWinnersAwarded,
  double? reward,
  String? rocketChannelId,
  int? winnersLimit,
  int? membersCount,
  int? winnersCount,
  Coin? coin,
  Channel? channel,
  Creator? creator,
  List<Winners>? winners,
  int? socialMedia,
  String? createdAt,
  String? finishedAt,
  String? expirationTime,
}) => ActiveGiveaway(  id: id ?? _id,
  isActive: isActive ?? _isActive,
  isCanceled: isCanceled ?? _isCanceled,
  isWinnersAwarded: isWinnersAwarded ?? _isWinnersAwarded,
  reward: reward ?? _reward,
  rocketChannelId: rocketChannelId ?? _rocketChannelId,
  winnersLimit: winnersLimit ?? _winnersLimit,
  membersCount: membersCount ?? _membersCount,
  winnersCount: winnersCount ?? _winnersCount,
  coin: coin ?? _coin,
  channel: channel ?? _channel,
  creator: creator ?? _creator,
  winners: winners ?? _winners,
  socialMedia: socialMedia ?? _socialMedia,
  createdAt: createdAt ?? _createdAt,
  finishedAt: finishedAt ?? _finishedAt,
  expirationTime: expirationTime ?? _expirationTime,
);
  int? get id => _id;
  bool? get isActive => _isActive;
  bool? get isCanceled => _isCanceled;
  bool? get isWinnersAwarded => _isWinnersAwarded;
  double? get reward => _reward;
  String? get rocketChannelId => _rocketChannelId;
  int? get winnersLimit => _winnersLimit;
  int? get membersCount => _membersCount;
  int? get winnersCount => _winnersCount;
  Coin? get coin => _coin;
  Channel? get channel => _channel;
  Creator? get creator => _creator;
  List<Winners>? get winners => _winners;
  int? get socialMedia => _socialMedia;
  String? get createdAt => _createdAt;
  String? get finishedAt => _finishedAt;
  String? get expirationTime => _expirationTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['isActive'] = _isActive;
    map['isCanceled'] = _isCanceled;
    map['isWinnersAwarded'] = _isWinnersAwarded;
    map['reward'] = _reward;
    map['rocketChannelId'] = _rocketChannelId;
    map['winnersLimit'] = _winnersLimit;
    map['membersCount'] = _membersCount;
    map['winnersCount'] = _winnersCount;
    if (_coin != null) {
      map['coin'] = _coin?.toJson();
    }
    if (_channel != null) {
      map['channel'] = _channel?.toJson();
    }
    if (_creator != null) {
      map['creator'] = _creator?.toJson();
    }
    if (_winners != null) {
      map['winners'] = _winners?.map((v) => v.toJson()).toList();
    }
    map['socialMedia'] = _socialMedia;
    map['createdAt'] = _createdAt;
    map['finishedAt'] = _finishedAt;
    map['expirationTime'] = _expirationTime;
    return map;
  }

}

/// id : 0
/// userId : 0
/// rocketAccountId : "0"
/// name : "string"
/// surname : "string"
/// username : "string"
/// imageId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// socialMedia : 1
/// connected : true
/// allowMentionInMessages : true
/// allowSendDirectMessages : true
/// followers : 0
/// verefied : true
/// registeredAt : "2022-07-10T23:02:54.604Z"
/// updatedAt : "2022-07-10T23:02:54.604Z"
/// mention : "string"

class Winners {
  Winners({
      int? id, 
      int? userId, 
      String? rocketAccountId, 
      String? name, 
      String? surname, 
      String? username, 
      String? imageId, 
      int? socialMedia, 
      bool? connected, 
      bool? allowMentionInMessages, 
      bool? allowSendDirectMessages, 
      int? followers, 
      bool? verefied, 
      String? registeredAt, 
      String? updatedAt, 
      String? mention,}){
    _id = id;
    _userId = userId;
    _rocketAccountId = rocketAccountId;
    _name = name;
    _surname = surname;
    _username = username;
    _imageId = imageId;
    _socialMedia = socialMedia;
    _connected = connected;
    _allowMentionInMessages = allowMentionInMessages;
    _allowSendDirectMessages = allowSendDirectMessages;
    _followers = followers;
    _verefied = verefied;
    _registeredAt = registeredAt;
    _updatedAt = updatedAt;
    _mention = mention;
}

  Winners.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _rocketAccountId = json['rocketAccountId'];
    _name = json['name'];
    _surname = json['surname'];
    _username = json['username'];
    _imageId = json['imageId'];
    _socialMedia = json['socialMedia'];
    _connected = json['connected'];
    _allowMentionInMessages = json['allowMentionInMessages'];
    _allowSendDirectMessages = json['allowSendDirectMessages'];
    _followers = json['followers'];
    _verefied = json['verefied'];
    _registeredAt = json['registeredAt'];
    _updatedAt = json['updatedAt'];
    _mention = json['mention'];
  }
  int? _id;
  int? _userId;
  String? _rocketAccountId;
  String? _name;
  String? _surname;
  String? _username;
  String? _imageId;
  int? _socialMedia;
  bool? _connected;
  bool? _allowMentionInMessages;
  bool? _allowSendDirectMessages;
  int? _followers;
  bool? _verefied;
  String? _registeredAt;
  String? _updatedAt;
  String? _mention;
Winners copyWith({  int? id,
  int? userId,
  String? rocketAccountId,
  String? name,
  String? surname,
  String? username,
  String? imageId,
  int? socialMedia,
  bool? connected,
  bool? allowMentionInMessages,
  bool? allowSendDirectMessages,
  int? followers,
  bool? verefied,
  String? registeredAt,
  String? updatedAt,
  String? mention,
}) => Winners(  id: id ?? _id,
  userId: userId ?? _userId,
  rocketAccountId: rocketAccountId ?? _rocketAccountId,
  name: name ?? _name,
  surname: surname ?? _surname,
  username: username ?? _username,
  imageId: imageId ?? _imageId,
  socialMedia: socialMedia ?? _socialMedia,
  connected: connected ?? _connected,
  allowMentionInMessages: allowMentionInMessages ?? _allowMentionInMessages,
  allowSendDirectMessages: allowSendDirectMessages ?? _allowSendDirectMessages,
  followers: followers ?? _followers,
  verefied: verefied ?? _verefied,
  registeredAt: registeredAt ?? _registeredAt,
  updatedAt: updatedAt ?? _updatedAt,
  mention: mention ?? _mention,
);
  int? get id => _id;
  int? get userId => _userId;
  String? get rocketAccountId => _rocketAccountId;
  String? get name => _name;
  String? get surname => _surname;
  String? get username => _username;
  String? get imageId => _imageId;
  int? get socialMedia => _socialMedia;
  bool? get connected => _connected;
  bool? get allowMentionInMessages => _allowMentionInMessages;
  bool? get allowSendDirectMessages => _allowSendDirectMessages;
  int? get followers => _followers;
  bool? get verefied => _verefied;
  String? get registeredAt => _registeredAt;
  String? get updatedAt => _updatedAt;
  String? get mention => _mention;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['rocketAccountId'] = _rocketAccountId;
    map['name'] = _name;
    map['surname'] = _surname;
    map['username'] = _username;
    map['imageId'] = _imageId;
    map['socialMedia'] = _socialMedia;
    map['connected'] = _connected;
    map['allowMentionInMessages'] = _allowMentionInMessages;
    map['allowSendDirectMessages'] = _allowSendDirectMessages;
    map['followers'] = _followers;
    map['verefied'] = _verefied;
    map['registeredAt'] = _registeredAt;
    map['updatedAt'] = _updatedAt;
    map['mention'] = _mention;
    return map;
  }

}
