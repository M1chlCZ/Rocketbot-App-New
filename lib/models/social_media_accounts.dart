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