/// notifications : [{"id":1,"idUser":1,"title":"2.5k MERGE Giveaway","body":"RT & Follow @VerifByHex","link":"https://twitter.com/PeterDWake/status/1545974780586852352","datePosted":"2022-07-13T19:02:14Z"},{"id":2,"idUser":1,"title":"$10 BUSD | 2hr","body":"RT & Follow @DfWplay","link":"https://twitter.com/DfWplay/status/1547318218343124992","datePosted":"2022-07-13T20:37:14Z"},{"id":3,"idUser":1,"title":"$20 BUSD Giveaway | 4h","body":"RT & Follow @andy23tran","link":"https://twitter.com/DfWplay/status/1547605751614488578","datePosted":"2022-07-14T15:38:09Z"},{"id":4,"idUser":1,"title":"$5 BUSD 1hr","body":"RT & Follow @DfWplay","link":"https://twitter.com/DfWplay/status/1550223599193231361","datePosted":"2022-07-21T20:58:33Z"},{"id":5,"idUser":1,"title":"v2 RocketBot","body":"Join our Beta, New features & Redesign","link":"https://twitter.com/rocketbotpro/status/1552305770397581315","datePosted":"2022-07-27T14:55:58Z"}]

class Notifications {
  Notifications({
      List<NotNode>? notifications,}){
    _notifications = notifications;
}

  Notifications.fromJson(dynamic json) {
    if (json['notifications'] != null) {
      _notifications = [];
      json['notifications'].forEach((v) {
        _notifications?.add(NotNode.fromJson(v));
      });
    }
  }
  List<NotNode>? _notifications;
  Notifications copyWith({  List<NotNode>? notifications,
}) => Notifications(  notifications: notifications ?? _notifications,
);
  List<NotNode>? get notifications => _notifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_notifications != null) {
      map['notifications'] = _notifications?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// idUser : 1
/// title : "2.5k MERGE Giveaway"
/// body : "RT & Follow @VerifByHex"
/// link : "https://twitter.com/PeterDWake/status/1545974780586852352"
/// datePosted : "2022-07-13T19:02:14Z"

class NotNode {
  NotNode({
      int? id, 
      int? idUser, 
      String? title, 
      String? body, 
      String? link,
    int? read,
      String? datePosted,}){
    _id = id;
    _idUser = idUser;
    _title = title;
    _body = body;
    _link = link;
    _read = read;
    _datePosted = datePosted;
}

  NotNode.fromJson(dynamic json) {
    _id = json['id'];
    _idUser = json['idUser'];
    _title = json['title'];
    _body = json['body'];
    _link = json['link'];
    _read = json['read'];
    _datePosted = json['datePosted'];
  }
  int? _id;
  int? _idUser;
  String? _title;
  String? _body;
  String? _link;
  int? _read;
  String? _datePosted;
NotNode copyWith({  int? id,
  int? idUser,
  String? title,
  String? body,
  String? link,
  int? read,
  String? datePosted,
}) => NotNode(  id: id ?? _id,
  idUser: idUser ?? _idUser,
  title: title ?? _title,
  body: body ?? _body,
  link: link ?? _link,
  read: read ?? _read,
  datePosted: datePosted ?? _datePosted,
);
  int? get id => _id;
  int? get idUser => _idUser;
  String? get title => _title;
  String? get body => _body;
  String? get link => _link;
  int? get read => _read;
  String? get datePosted => _datePosted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['idUser'] = _idUser;
    map['title'] = _title;
    map['body'] = _body;
    map['link'] = _link;
    map['read'] = _read;
    map['datePosted'] = _datePosted;
    return map;
  }

}