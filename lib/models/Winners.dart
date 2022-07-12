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
      this.id, 
      this.userId, 
      this.rocketAccountId, 
      this.name, 
      this.surname, 
      this.username, 
      this.imageId, 
      this.socialMedia, 
      this.connected, 
      this.allowMentionInMessages, 
      this.allowSendDirectMessages, 
      this.followers, 
      this.verefied, 
      this.registeredAt, 
      this.updatedAt, 
      this.mention,});

  Winners.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    rocketAccountId = json['rocketAccountId'];
    name = json['name'];
    surname = json['surname'];
    username = json['username'];
    imageId = json['imageId'];
    socialMedia = json['socialMedia'];
    connected = json['connected'];
    allowMentionInMessages = json['allowMentionInMessages'];
    allowSendDirectMessages = json['allowSendDirectMessages'];
    followers = json['followers'];
    verefied = json['verefied'];
    registeredAt = json['registeredAt'];
    updatedAt = json['updatedAt'];
    mention = json['mention'];
  }
  int? id;
  int? userId;
  String? rocketAccountId;
  String? name;
  String? surname;
  String? username;
  String? imageId;
  int? socialMedia;
  bool? connected;
  bool? allowMentionInMessages;
  bool? allowSendDirectMessages;
  int? followers;
  bool? verefied;
  String? registeredAt;
  String? updatedAt;
  String? mention;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['rocketAccountId'] = rocketAccountId;
    map['name'] = name;
    map['surname'] = surname;
    map['username'] = username;
    map['imageId'] = imageId;
    map['socialMedia'] = socialMedia;
    map['connected'] = connected;
    map['allowMentionInMessages'] = allowMentionInMessages;
    map['allowSendDirectMessages'] = allowSendDirectMessages;
    map['followers'] = followers;
    map['verefied'] = verefied;
    map['registeredAt'] = registeredAt;
    map['updatedAt'] = updatedAt;
    map['mention'] = mention;
    return map;
  }

}