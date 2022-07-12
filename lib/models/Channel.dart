/// id : 0
/// rocketChannelId : "0"
/// socialMedia : 1
/// name : "string"
/// url : "string"
/// imageId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// followers : 0
/// updatedAt : "2022-07-10T23:02:54.604Z"

class Channel {
  Channel({
      this.id, 
      this.rocketChannelId, 
      this.socialMedia, 
      this.name, 
      this.url, 
      this.imageId, 
      this.followers, 
      this.updatedAt,});

  Channel.fromJson(dynamic json) {
    id = json['id'];
    rocketChannelId = json['rocketChannelId'].toString();
    socialMedia = json['socialMedia'];
    name = json['name'];
    url = json['url'];
    imageId = json['imageId'];
    followers = json['followers'];
    updatedAt = json['updatedAt'];
  }
  int? id;
  String? rocketChannelId;
  int? socialMedia;
  String? name;
  String? url;
  String? imageId;
  int? followers;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['rocketChannelId'] = rocketChannelId;
    map['socialMedia'] = socialMedia;
    map['name'] = name;
    map['url'] = url;
    map['imageId'] = imageId;
    map['followers'] = followers;
    map['updatedAt'] = updatedAt;
    return map;
  }

}