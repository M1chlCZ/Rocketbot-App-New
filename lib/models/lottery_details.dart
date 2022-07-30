import 'package:rocketbot/models/coin.dart';

/// message : "string"
/// hasError : true
/// error : "string"
/// data : {"id":0,"reward":0.0,"rocketChannelId":"0","membersLimit":0,"membersCount":0,"isActive":true,"expired":true,"creatorRewardPercent":0,"coin":{"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0.0,"blockchain":0,"minWithdraw":0.0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true},"channel":{"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-30T16:01:19.205Z"},"creator":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-30T16:01:19.205Z","updatedAt":"2022-07-30T16:01:19.205Z","mention":"string"},"winner":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-30T16:01:19.205Z","updatedAt":"2022-07-30T16:01:19.205Z","mention":"string"},"socialMedia":1,"createdAt":"2022-07-30T16:01:19.205Z","finishedAt":"2022-07-30T16:01:19.205Z","members":[{"received":"2022-07-30T16:01:19.205Z","socialMediaAccount":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-30T16:01:19.205Z","updatedAt":"2022-07-30T16:01:19.205Z","mention":"string"}}]}

class LotteryDetails {
  LotteryDetails({
      String? message, 
      bool? hasError, 
      String? error, 
      LotteryDetailsData? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  LotteryDetails.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'] != null ? LotteryDetailsData.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _hasError;
  String? _error;
  LotteryDetailsData? _data;
LotteryDetails copyWith({  String? message,
  bool? hasError,
  String? error,
  LotteryDetailsData? data,
}) => LotteryDetails(  message: message ?? _message,
  hasError: hasError ?? _hasError,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  LotteryDetailsData? get data => _data;

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
/// reward : 0.0
/// rocketChannelId : "0"
/// membersLimit : 0
/// membersCount : 0
/// isActive : true
/// expired : true
/// creatorRewardPercent : 0
/// coin : {"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0.0,"blockchain":0,"minWithdraw":0.0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true}
/// channel : {"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-30T16:01:19.205Z"}
/// creator : {"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-30T16:01:19.205Z","updatedAt":"2022-07-30T16:01:19.205Z","mention":"string"}
/// winner : {"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-30T16:01:19.205Z","updatedAt":"2022-07-30T16:01:19.205Z","mention":"string"}
/// socialMedia : 1
/// createdAt : "2022-07-30T16:01:19.205Z"
/// finishedAt : "2022-07-30T16:01:19.205Z"
/// members : [{"received":"2022-07-30T16:01:19.205Z","socialMediaAccount":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-30T16:01:19.205Z","updatedAt":"2022-07-30T16:01:19.205Z","mention":"string"}}]

class LotteryDetailsData {
  LotteryDetailsData({
      int? id, 
      double? reward, 
      String? rocketChannelId, 
      int? membersLimit, 
      int? membersCount, 
      bool? isActive, 
      bool? expired, 
      int? creatorRewardPercent, 
      Coin? coin, 
      Channel? channel, 
      Creator? creator, 
      Winner? winner, 
      int? socialMedia, 
      String? createdAt, 
      String? finishedAt, 
      List<Members>? members,}){
    _id = id;
    _reward = reward;
    _rocketChannelId = rocketChannelId;
    _membersLimit = membersLimit;
    _membersCount = membersCount;
    _isActive = isActive;
    _expired = expired;
    _creatorRewardPercent = creatorRewardPercent;
    _coin = coin;
    _channel = channel;
    _creator = creator;
    _winner = winner;
    _socialMedia = socialMedia;
    _createdAt = createdAt;
    _finishedAt = finishedAt;
    _members = members;
}

  LotteryDetailsData.fromJson(dynamic json) {
    _id = json['id'];
    _reward = double.parse(json['reward'].toString());
    _rocketChannelId = json['rocketChannelId'].toString();
    _membersLimit = json['membersLimit'];
    _membersCount = json['membersCount'];
    _isActive = json['isActive'];
    _expired = json['expired'];
    _creatorRewardPercent = json['creatorRewardPercent'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _channel = json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    _creator = json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    _winner = json['winner'] != null ? Winner.fromJson(json['winner']) : null;
    _socialMedia = json['socialMedia'];
    _createdAt = json['createdAt'];
    _finishedAt = json['finishedAt'];
    if (json['members'] != null) {
      _members = [];
      json['members'].forEach((v) {
        _members?.add(Members.fromJson(v));
      });
    }
  }
  int? _id;
  double? _reward;
  String? _rocketChannelId;
  int? _membersLimit;
  int? _membersCount;
  bool? _isActive;
  bool? _expired;
  int? _creatorRewardPercent;
  Coin? _coin;
  Channel? _channel;
  Creator? _creator;
  Winner? _winner;
  int? _socialMedia;
  String? _createdAt;
  String? _finishedAt;
  List<Members>? _members;
LotteryDetailsData copyWith({  int? id,
  double? reward,
  String? rocketChannelId,
  int? membersLimit,
  int? membersCount,
  bool? isActive,
  bool? expired,
  int? creatorRewardPercent,
  Coin? coin,
  Channel? channel,
  Creator? creator,
  Winner? winner,
  int? socialMedia,
  String? createdAt,
  String? finishedAt,
  List<Members>? members,
}) => LotteryDetailsData(  id: id ?? _id,
  reward: reward ?? _reward,
  rocketChannelId: rocketChannelId ?? _rocketChannelId,
  membersLimit: membersLimit ?? _membersLimit,
  membersCount: membersCount ?? _membersCount,
  isActive: isActive ?? _isActive,
  expired: expired ?? _expired,
  creatorRewardPercent: creatorRewardPercent ?? _creatorRewardPercent,
  coin: coin ?? _coin,
  channel: channel ?? _channel,
  creator: creator ?? _creator,
  winner: winner ?? _winner,
  socialMedia: socialMedia ?? _socialMedia,
  createdAt: createdAt ?? _createdAt,
  finishedAt: finishedAt ?? _finishedAt,
  members: members ?? _members,
);
  int? get id => _id;
  double? get reward => _reward;
  String? get rocketChannelId => _rocketChannelId;
  int? get membersLimit => _membersLimit;
  int? get membersCount => _membersCount;
  bool? get isActive => _isActive;
  bool? get expired => _expired;
  int? get creatorRewardPercent => _creatorRewardPercent;
  Coin? get coin => _coin;
  Channel? get channel => _channel;
  Creator? get creator => _creator;
  Winner? get winner => _winner;
  int? get socialMedia => _socialMedia;
  String? get createdAt => _createdAt;
  String? get finishedAt => _finishedAt;
  List<Members>? get members => _members;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['reward'] = _reward;
    map['rocketChannelId'] = _rocketChannelId;
    map['membersLimit'] = _membersLimit;
    map['membersCount'] = _membersCount;
    map['isActive'] = _isActive;
    map['expired'] = _expired;
    map['creatorRewardPercent'] = _creatorRewardPercent;
    if (_coin != null) {
      map['coin'] = _coin?.toJson();
    }
    if (_channel != null) {
      map['channel'] = _channel?.toJson();
    }
    if (_creator != null) {
      map['creator'] = _creator?.toJson();
    }
    if (_winner != null) {
      map['winner'] = _winner?.toJson();
    }
    map['socialMedia'] = _socialMedia;
    map['createdAt'] = _createdAt;
    map['finishedAt'] = _finishedAt;
    if (_members != null) {
      map['members'] = _members?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// received : "2022-07-30T16:01:19.205Z"
/// socialMediaAccount : {"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-30T16:01:19.205Z","updatedAt":"2022-07-30T16:01:19.205Z","mention":"string"}

class Members {
  Members({
      String? received,
      SocialMediaAccount? socialMediaAccount,}){
    _received = received;
    _socialMediaAccount = socialMediaAccount;
}

  Members.fromJson(dynamic json) {
    _received = json['received'];
    _socialMediaAccount = json['socialMediaAccount'] != null ? SocialMediaAccount.fromJson(json['socialMediaAccount']) : null;
  }
  String? _received;
  SocialMediaAccount? _socialMediaAccount;
Members copyWith({  String? received,
  SocialMediaAccount? socialMediaAccount,
}) => Members(  received: received ?? _received,
  socialMediaAccount: socialMediaAccount ?? _socialMediaAccount,
);
  String? get received => _received;
  SocialMediaAccount? get socialMediaAccount => _socialMediaAccount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['received'] = _received;
    if (_socialMediaAccount != null) {
      map['socialMediaAccount'] = _socialMediaAccount?.toJson();
    }
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
/// registeredAt : "2022-07-30T16:01:19.205Z"
/// updatedAt : "2022-07-30T16:01:19.205Z"
/// mention : "string"

class SocialMediaAccount {
  SocialMediaAccount({
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

  SocialMediaAccount.fromJson(dynamic json) {
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
SocialMediaAccount copyWith({  int? id,
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
}) => SocialMediaAccount(  id: id ?? _id,
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
/// registeredAt : "2022-07-30T16:01:19.205Z"
/// updatedAt : "2022-07-30T16:01:19.205Z"
/// mention : "string"

class Winner {
  Winner({
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

  Winner.fromJson(dynamic json) {
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
Winner copyWith({  int? id,
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
}) => Winner(  id: id ?? _id,
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
/// registeredAt : "2022-07-30T16:01:19.205Z"
/// updatedAt : "2022-07-30T16:01:19.205Z"
/// mention : "string"

class Creator {
  Creator({
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

  Creator.fromJson(dynamic json) {
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
Creator copyWith({  int? id,
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
}) => Creator(  id: id ?? _id,
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

/// id : 0
/// rocketChannelId : "0"
/// socialMedia : 1
/// name : "string"
/// url : "string"
/// imageId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// followers : 0
/// updatedAt : "2022-07-30T16:01:19.205Z"

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
