import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/social_media_accounts.dart';

import 'Channel.dart';
import 'Creator.dart';
import 'members.dart';

/// message : "string"
/// hasError : true
/// error : "string"
/// data : {"id":0,"isActive":true,"reward":0,"rocketChannelId":0,"membersLimit":0,"membersCount":0,"coin":{"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0.0,"blockchain":0,"minWithdraw":0.0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true},"channel":{"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-12T21:43:13.539Z"},"creator":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-12T21:43:13.539Z","updatedAt":"2022-07-12T21:43:13.539Z","mention":"string"},"members":[{"received":"2022-07-12T21:43:13.539Z","socialMediaAccount":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-12T21:43:13.539Z","updatedAt":"2022-07-12T21:43:13.539Z","mention":"string"}}],"socialMedia":1,"createdAt":"2022-07-12T21:43:13.539Z","finishedAt":"2022-07-12T21:43:13.539Z"}

class AirdropDetails {
  AirdropDetails({
      String? message, 
      bool? hasError, 
      String? error, 
      Data? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  AirdropDetails.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _hasError;
  String? _error;
  Data? _data;
AirdropDetails copyWith({  String? message,
  bool? hasError,
  String? error,
  Data? data,
}) => AirdropDetails(  message: message ?? _message,
  hasError: hasError ?? _hasError,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  Data? get data => _data;

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
/// reward : 0
/// rocketChannelId : 0
/// membersLimit : 0
/// membersCount : 0
/// coin : {"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0.0,"blockchain":0,"minWithdraw":0.0,"bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true}
/// channel : {"id":0,"rocketChannelId":"0","socialMedia":1,"name":"string","url":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","followers":0,"updatedAt":"2022-07-12T21:43:13.539Z"}
/// creator : {"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-12T21:43:13.539Z","updatedAt":"2022-07-12T21:43:13.539Z","mention":"string"}
/// members : [{"received":"2022-07-12T21:43:13.539Z","socialMediaAccount":{"id":0,"userId":0,"rocketAccountId":"0","name":"string","surname":"string","username":"string","imageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","socialMedia":1,"connected":true,"allowMentionInMessages":true,"allowSendDirectMessages":true,"followers":0,"verefied":true,"registeredAt":"2022-07-12T21:43:13.539Z","updatedAt":"2022-07-12T21:43:13.539Z","mention":"string"}}]
/// socialMedia : 1
/// createdAt : "2022-07-12T21:43:13.539Z"
/// finishedAt : "2022-07-12T21:43:13.539Z"

class Data {
  Data({
      int? id, 
      bool? isActive, 
      int? reward, 
      int? rocketChannelId, 
      int? membersLimit, 
      int? membersCount, 
      Coin? coin, 
      Channel? channel, 
      Creator? creator, 
      List<Members>? members, 
      int? socialMedia, 
      String? createdAt, 
      String? finishedAt,}){
    _id = id;
    _isActive = isActive;
    _reward = reward;
    _rocketChannelId = rocketChannelId;
    _membersLimit = membersLimit;
    _membersCount = membersCount;
    _coin = coin;
    _channel = channel;
    _creator = creator;
    _members = members;
    _socialMedia = socialMedia;
    _createdAt = createdAt;
    _finishedAt = finishedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _isActive = json['isActive'];
    _reward = json['reward'];
    _rocketChannelId = json['rocketChannelId'];
    _membersLimit = json['membersLimit'];
    _membersCount = json['membersCount'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _channel = json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    _creator = json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    if (json['members'] != null) {
      _members = [];
      json['members'].forEach((v) {
        _members?.add(Members.fromJson(v));
      });
    }
    _socialMedia = json['socialMedia'];
    _createdAt = json['createdAt'];
    _finishedAt = json['finishedAt'];
  }
  int? _id;
  bool? _isActive;
  int? _reward;
  int? _rocketChannelId;
  int? _membersLimit;
  int? _membersCount;
  Coin? _coin;
  Channel? _channel;
  Creator? _creator;
  List<Members>? _members;
  int? _socialMedia;
  String? _createdAt;
  String? _finishedAt;
Data copyWith({  int? id,
  bool? isActive,
  int? reward,
  int? rocketChannelId,
  int? membersLimit,
  int? membersCount,
  Coin? coin,
  Channel? channel,
  Creator? creator,
  List<Members>? members,
  int? socialMedia,
  String? createdAt,
  String? finishedAt,
}) => Data(  id: id ?? _id,
  isActive: isActive ?? _isActive,
  reward: reward ?? _reward,
  rocketChannelId: rocketChannelId ?? _rocketChannelId,
  membersLimit: membersLimit ?? _membersLimit,
  membersCount: membersCount ?? _membersCount,
  coin: coin ?? _coin,
  channel: channel ?? _channel,
  creator: creator ?? _creator,
  members: members ?? _members,
  socialMedia: socialMedia ?? _socialMedia,
  createdAt: createdAt ?? _createdAt,
  finishedAt: finishedAt ?? _finishedAt,
);
  int? get id => _id;
  bool? get isActive => _isActive;
  int? get reward => _reward;
  int? get rocketChannelId => _rocketChannelId;
  int? get membersLimit => _membersLimit;
  int? get membersCount => _membersCount;
  Coin? get coin => _coin;
  Channel? get channel => _channel;
  Creator? get creator => _creator;
  List<Members>? get members => _members;
  int? get socialMedia => _socialMedia;
  String? get createdAt => _createdAt;
  String? get finishedAt => _finishedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['isActive'] = _isActive;
    map['reward'] = _reward;
    map['rocketChannelId'] = _rocketChannelId;
    map['membersLimit'] = _membersLimit;
    map['membersCount'] = _membersCount;
    if (_coin != null) {
      map['coin'] = _coin?.toJson();
    }
    if (_channel != null) {
      map['channel'] = _channel?.toJson();
    }
    if (_creator != null) {
      map['creator'] = _creator?.toJson();
    }
    if (_members != null) {
      map['members'] = _members?.map((v) => v.toJson()).toList();
    }
    map['socialMedia'] = _socialMedia;
    map['createdAt'] = _createdAt;
    map['finishedAt'] = _finishedAt;
    return map;
  }

}
