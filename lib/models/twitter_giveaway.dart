/// message : "string"
/// hasError : true
/// error : "string"
/// data : {"id":0,"isActive":true,"isCanceled":true,"isWinnersAwarded":true,"reward":0,"rocketChannelId":"0","winnersLimit":0,"membersCount":0,"winnersCount":0,"coin":{"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0.0,"blockchain":0,"minWithdraw":0.0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true},"channel":{"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-24T01:57:42.173Z"},"creator":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"},"winners":[{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"}],"socialMedia":1,"createdAt":"2022-07-24T01:57:42.173Z","finishedAt":"2022-07-24T01:57:42.173Z","expirationTime":"2022-07-24T01:57:42.173Z","conditions":{"memberProfileFilter":{"description":true,"banner":true,"picture":true,"accountAgeInDays":0},"mustFollowAccounts":[{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"}]},"followersIncrease":[{"socialMediaAccount":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"},"followersOnStart":0,"followersOnEnd":0}]}

class TwitterGiveaways {
  TwitterGiveaways({
      String? message, 
      bool? hasError, 
      String? error, 
      TwitterGiveaway? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  TwitterGiveaways.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'] != null ? TwitterGiveaway.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _hasError;
  String? _error;
  TwitterGiveaway? _data;
TwitterGiveaways copyWith({  String? message,
  bool? hasError,
  String? error,
  TwitterGiveaway? data,
}) => TwitterGiveaways(  message: message ?? _message,
  hasError: hasError ?? _hasError,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  TwitterGiveaway? get data => _data;

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
/// channel : {"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-24T01:57:42.173Z"}
/// creator : {"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"}
/// winners : [{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"}]
/// socialMedia : 1
/// createdAt : "2022-07-24T01:57:42.173Z"
/// finishedAt : "2022-07-24T01:57:42.173Z"
/// expirationTime : "2022-07-24T01:57:42.173Z"
/// conditions : {"memberProfileFilter":{"description":true,"banner":true,"picture":true,"accountAgeInDays":0},"mustFollowAccounts":[{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"}]}
/// followersIncrease : [{"socialMediaAccount":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"},"followersOnStart":0,"followersOnEnd":0}]

class TwitterGiveaway {
  TwitterGiveaway({
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
      String? expirationTime, 
      Conditions? conditions, 
      List<FollowersIncrease>? followersIncrease,}){
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
    _conditions = conditions;
    _followersIncrease = followersIncrease;
}

  TwitterGiveaway.fromJson(dynamic json) {
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
    _conditions = json['conditions'] != null ? Conditions.fromJson(json['conditions']) : null;
    if (json['followersIncrease'] != null) {
      _followersIncrease = [];
      json['followersIncrease'].forEach((v) {
        _followersIncrease?.add(FollowersIncrease.fromJson(v));
      });
    }
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
  Conditions? _conditions;
  List<FollowersIncrease>? _followersIncrease;
TwitterGiveaway copyWith({  int? id,
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
  Conditions? conditions,
  List<FollowersIncrease>? followersIncrease,
}) => TwitterGiveaway(  id: id ?? _id,
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
  conditions: conditions ?? _conditions,
  followersIncrease: followersIncrease ?? _followersIncrease,
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
  Conditions? get conditions => _conditions;
  List<FollowersIncrease>? get followersIncrease => _followersIncrease;

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
    if (_conditions != null) {
      map['conditions'] = _conditions?.toJson();
    }
    if (_followersIncrease != null) {
      map['followersIncrease'] = _followersIncrease?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// socialMediaAccount : {"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"}
/// followersOnStart : 0
/// followersOnEnd : 0

class FollowersIncrease {
  FollowersIncrease({
      SocialMediaAccount? socialMediaAccount, 
      int? followersOnStart, 
      int? followersOnEnd,}){
    _socialMediaAccount = socialMediaAccount;
    _followersOnStart = followersOnStart;
    _followersOnEnd = followersOnEnd;
}

  FollowersIncrease.fromJson(dynamic json) {
    _socialMediaAccount = json['socialMediaAccount'] != null ? SocialMediaAccount.fromJson(json['socialMediaAccount']) : null;
    _followersOnStart = json['followersOnStart'];
    _followersOnEnd = json['followersOnEnd'];
  }
  SocialMediaAccount? _socialMediaAccount;
  int? _followersOnStart;
  int? _followersOnEnd;
FollowersIncrease copyWith({  SocialMediaAccount? socialMediaAccount,
  int? followersOnStart,
  int? followersOnEnd,
}) => FollowersIncrease(  socialMediaAccount: socialMediaAccount ?? _socialMediaAccount,
  followersOnStart: followersOnStart ?? _followersOnStart,
  followersOnEnd: followersOnEnd ?? _followersOnEnd,
);
  SocialMediaAccount? get socialMediaAccount => _socialMediaAccount;
  int? get followersOnStart => _followersOnStart;
  int? get followersOnEnd => _followersOnEnd;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_socialMediaAccount != null) {
      map['socialMediaAccount'] = _socialMediaAccount?.toJson();
    }
    map['followersOnStart'] = _followersOnStart;
    map['followersOnEnd'] = _followersOnEnd;
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
/// registeredAt : "2022-07-24T01:57:42.173Z"
/// updatedAt : "2022-07-24T01:57:42.173Z"
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
    _rocketAccountId = json['rocketAccountId'].toString();
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

/// memberProfileFilter : {"description":true,"banner":true,"picture":true,"accountAgeInDays":0}
/// mustFollowAccounts : [{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-24T01:57:42.173Z","updatedAt":"2022-07-24T01:57:42.173Z","mention":"string"}]

class Conditions {
  Conditions({
      MemberProfileFilter? memberProfileFilter, 
      List<MustFollowAccounts>? mustFollowAccounts,}){
    _memberProfileFilter = memberProfileFilter;
    _mustFollowAccounts = mustFollowAccounts;
}

  Conditions.fromJson(dynamic json) {
    _memberProfileFilter = json['memberProfileFilter'] != null ? MemberProfileFilter.fromJson(json['memberProfileFilter']) : null;
    if (json['mustFollowAccounts'] != null) {
      _mustFollowAccounts = [];
      json['mustFollowAccounts'].forEach((v) {
        _mustFollowAccounts?.add(MustFollowAccounts.fromJson(v));
      });
    }
  }
  MemberProfileFilter? _memberProfileFilter;
  List<MustFollowAccounts>? _mustFollowAccounts;
Conditions copyWith({  MemberProfileFilter? memberProfileFilter,
  List<MustFollowAccounts>? mustFollowAccounts,
}) => Conditions(  memberProfileFilter: memberProfileFilter ?? _memberProfileFilter,
  mustFollowAccounts: mustFollowAccounts ?? _mustFollowAccounts,
);
  MemberProfileFilter? get memberProfileFilter => _memberProfileFilter;
  List<MustFollowAccounts>? get mustFollowAccounts => _mustFollowAccounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_memberProfileFilter != null) {
      map['memberProfileFilter'] = _memberProfileFilter?.toJson();
    }
    if (_mustFollowAccounts != null) {
      map['mustFollowAccounts'] = _mustFollowAccounts?.map((v) => v.toJson()).toList();
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
/// registeredAt : "2022-07-24T01:57:42.173Z"
/// updatedAt : "2022-07-24T01:57:42.173Z"
/// mention : "string"

class MustFollowAccounts {
  MustFollowAccounts({
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

  MustFollowAccounts.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _rocketAccountId = json['rocketAccountId'].toString();
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
MustFollowAccounts copyWith({  int? id,
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
}) => MustFollowAccounts(  id: id ?? _id,
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

/// description : true
/// banner : true
/// picture : true
/// accountAgeInDays : 0

class MemberProfileFilter {
  MemberProfileFilter({
      bool? description, 
      bool? banner, 
      bool? picture, 
      int? accountAgeInDays,}){
    _description = description;
    _banner = banner;
    _picture = picture;
    _accountAgeInDays = accountAgeInDays;
}

  MemberProfileFilter.fromJson(dynamic json) {
    _description = json['description'];
    _banner = json['banner'];
    _picture = json['picture'];
    _accountAgeInDays = json['accountAgeInDays'];
  }
  bool? _description;
  bool? _banner;
  bool? _picture;
  int? _accountAgeInDays;
MemberProfileFilter copyWith({  bool? description,
  bool? banner,
  bool? picture,
  int? accountAgeInDays,
}) => MemberProfileFilter(  description: description ?? _description,
  banner: banner ?? _banner,
  picture: picture ?? _picture,
  accountAgeInDays: accountAgeInDays ?? _accountAgeInDays,
);
  bool? get description => _description;
  bool? get banner => _banner;
  bool? get picture => _picture;
  int? get accountAgeInDays => _accountAgeInDays;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['banner'] = _banner;
    map['picture'] = _picture;
    map['accountAgeInDays'] = _accountAgeInDays;
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
/// registeredAt : "2022-07-24T01:57:42.173Z"
/// updatedAt : "2022-07-24T01:57:42.173Z"
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
    _rocketAccountId = json['rocketAccountId'].toString();
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
/// registeredAt : "2022-07-24T01:57:42.173Z"
/// updatedAt : "2022-07-24T01:57:42.173Z"
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
    _rocketAccountId = json['rocketAccountId'].toString();
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
/// updatedAt : "2022-07-24T01:57:42.173Z"

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

/// id : 0
/// rank : 0
/// name : "string"
/// ticker : "string"
/// cryptoId : "string"
/// isToken : true
/// contractAddress : "string"
/// feePercent : 0.0
/// blockchain : 0
/// minWithdraw : 0.0
/// bigImageId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// smallImageId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// isActive : true
/// explorerUrl : "string"
/// requiredConfirmations : 0
/// fullName : "string"
/// tokenStandart : "string"
/// allowWithdraws : true
/// allowDeposits : true

class Coin {
  Coin({
      int? id, 
      int? rank, 
      String? name, 
      String? ticker, 
      String? cryptoId, 
      bool? isToken, 
      String? contractAddress, 
      double? feePercent, 
      int? blockchain, 
      double? minWithdraw, 
      String? bigImageId, 
      String? smallImageId, 
      bool? isActive, 
      String? explorerUrl, 
      int? requiredConfirmations, 
      String? fullName, 
      String? tokenStandart, 
      bool? allowWithdraws, 
      bool? allowDeposits,}){
    _id = id;
    _rank = rank;
    _name = name;
    _ticker = ticker;
    _cryptoId = cryptoId;
    _isToken = isToken;
    _contractAddress = contractAddress;
    _feePercent = feePercent;
    _blockchain = blockchain;
    _minWithdraw = minWithdraw;
    _bigImageId = bigImageId;
    _smallImageId = smallImageId;
    _isActive = isActive;
    _explorerUrl = explorerUrl;
    _requiredConfirmations = requiredConfirmations;
    _fullName = fullName;
    _tokenStandart = tokenStandart;
    _allowWithdraws = allowWithdraws;
    _allowDeposits = allowDeposits;
}

  Coin.fromJson(dynamic json) {
    _id = json['id'];
    _rank = json['rank'];
    _name = json['name'];
    _ticker = json['ticker'];
    _cryptoId = json['cryptoId'];
    _isToken = json['isToken'];
    _contractAddress = json['contractAddress'];
    _feePercent = double.parse(json['feePercent'].toString());
    _blockchain = json['blockchain'];
    _minWithdraw = double.parse(json['minWithdraw'].toString());
    _bigImageId = json['bigImageId'];
    _smallImageId = json['smallImageId'];
    _isActive = json['isActive'];
    _explorerUrl = json['explorerUrl'];
    _requiredConfirmations = json['requiredConfirmations'];
    _fullName = json['fullName'];
    _tokenStandart = json['tokenStandart'];
    _allowWithdraws = json['allowWithdraws'];
    _allowDeposits = json['allowDeposits'];
  }
  int? _id;
  int? _rank;
  String? _name;
  String? _ticker;
  String? _cryptoId;
  bool? _isToken;
  String? _contractAddress;
  double? _feePercent;
  int? _blockchain;
  double? _minWithdraw;
  String? _bigImageId;
  String? _smallImageId;
  bool? _isActive;
  String? _explorerUrl;
  int? _requiredConfirmations;
  String? _fullName;
  String? _tokenStandart;
  bool? _allowWithdraws;
  bool? _allowDeposits;
Coin copyWith({  int? id,
  int? rank,
  String? name,
  String? ticker,
  String? cryptoId,
  bool? isToken,
  String? contractAddress,
  double? feePercent,
  int? blockchain,
  double? minWithdraw,
  String? bigImageId,
  String? smallImageId,
  bool? isActive,
  String? explorerUrl,
  int? requiredConfirmations,
  String? fullName,
  String? tokenStandart,
  bool? allowWithdraws,
  bool? allowDeposits,
}) => Coin(  id: id ?? _id,
  rank: rank ?? _rank,
  name: name ?? _name,
  ticker: ticker ?? _ticker,
  cryptoId: cryptoId ?? _cryptoId,
  isToken: isToken ?? _isToken,
  contractAddress: contractAddress ?? _contractAddress,
  feePercent: feePercent ?? _feePercent,
  blockchain: blockchain ?? _blockchain,
  minWithdraw: minWithdraw ?? _minWithdraw,
  bigImageId: bigImageId ?? _bigImageId,
  smallImageId: smallImageId ?? _smallImageId,
  isActive: isActive ?? _isActive,
  explorerUrl: explorerUrl ?? _explorerUrl,
  requiredConfirmations: requiredConfirmations ?? _requiredConfirmations,
  fullName: fullName ?? _fullName,
  tokenStandart: tokenStandart ?? _tokenStandart,
  allowWithdraws: allowWithdraws ?? _allowWithdraws,
  allowDeposits: allowDeposits ?? _allowDeposits,
);
  int? get id => _id;
  int? get rank => _rank;
  String? get name => _name;
  String? get ticker => _ticker;
  String? get cryptoId => _cryptoId;
  bool? get isToken => _isToken;
  String? get contractAddress => _contractAddress;
  double? get feePercent => _feePercent;
  int? get blockchain => _blockchain;
  double? get minWithdraw => _minWithdraw;
  String? get bigImageId => _bigImageId;
  String? get smallImageId => _smallImageId;
  bool? get isActive => _isActive;
  String? get explorerUrl => _explorerUrl;
  int? get requiredConfirmations => _requiredConfirmations;
  String? get fullName => _fullName;
  String? get tokenStandart => _tokenStandart;
  bool? get allowWithdraws => _allowWithdraws;
  bool? get allowDeposits => _allowDeposits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['rank'] = _rank;
    map['name'] = _name;
    map['ticker'] = _ticker;
    map['cryptoId'] = _cryptoId;
    map['isToken'] = _isToken;
    map['contractAddress'] = _contractAddress;
    map['feePercent'] = _feePercent;
    map['blockchain'] = _blockchain;
    map['minWithdraw'] = _minWithdraw;
    map['bigImageId'] = _bigImageId;
    map['smallImageId'] = _smallImageId;
    map['isActive'] = _isActive;
    map['explorerUrl'] = _explorerUrl;
    map['requiredConfirmations'] = _requiredConfirmations;
    map['fullName'] = _fullName;
    map['tokenStandart'] = _tokenStandart;
    map['allowWithdraws'] = _allowWithdraws;
    map['allowDeposits'] = _allowDeposits;
    return map;
  }

}