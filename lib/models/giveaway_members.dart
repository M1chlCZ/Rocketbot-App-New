/// message : "string"
/// hasError : true
/// error : "string"
/// data : [{"participateAt":"2022-07-12T17:42:52.311Z","socialMediaAccount":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-12T17:42:52.311Z","updatedAt":"2022-07-12T17:42:52.311Z","mention":"string"}}]

class GiveawayMembers {
  GiveawayMembers({
      String? message, 
      bool? hasError, 
      String? error, 
      List<Members>? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  GiveawayMembers.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Members.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _hasError;
  String? _error;
  List<Members>? _data;
GiveawayMembers copyWith({  String? message,
  bool? hasError,
  String? error,
  List<Members>? data,
}) => GiveawayMembers(  message: message ?? _message,
  hasError: hasError ?? _hasError,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  List<Members>? get data => _data;

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

/// participateAt : "2022-07-12T17:42:52.311Z"
/// socialMediaAccount : {"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-12T17:42:52.311Z","updatedAt":"2022-07-12T17:42:52.311Z","mention":"string"}

class Members {
  Members({
      String? participateAt, 
      SocialMediaAccount? socialMediaAccount,}){
    _participateAt = participateAt;
    _socialMediaAccount = socialMediaAccount;
}

  Members.fromJson(dynamic json) {
    _participateAt = json['participateAt'];
    _socialMediaAccount = json['socialMediaAccount'] != null ? SocialMediaAccount.fromJson(json['socialMediaAccount']) : null;
  }
  String? _participateAt;
  SocialMediaAccount? _socialMediaAccount;
Members copyWith({  String? participateAt,
  SocialMediaAccount? socialMediaAccount,
}) => Members(  participateAt: participateAt ?? _participateAt,
  socialMediaAccount: socialMediaAccount ?? _socialMediaAccount,
);
  String? get participateAt => _participateAt;
  SocialMediaAccount? get socialMediaAccount => _socialMediaAccount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['participateAt'] = _participateAt;
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
/// registeredAt : "2022-07-12T17:42:52.311Z"
/// updatedAt : "2022-07-12T17:42:52.311Z"
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