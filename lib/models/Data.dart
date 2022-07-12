import 'Coin.dart';
import 'Channel.dart';
import 'Creator.dart';
import 'Winners.dart';

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

class Data {
  Data({
      this.id, 
      this.isActive, 
      this.isCanceled, 
      this.isWinnersAwarded, 
      this.reward, 
      this.rocketChannelId, 
      this.winnersLimit, 
      this.membersCount, 
      this.winnersCount, 
      this.coin, 
      this.channel, 
      this.creator, 
      this.winners, 
      this.socialMedia, 
      this.createdAt, 
      this.finishedAt, 
      this.expirationTime,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    isActive = json['isActive'];
    isCanceled = json['isCanceled'];
    isWinnersAwarded = json['isWinnersAwarded'];
    reward = json['reward'];
    rocketChannelId = json['rocketChannelId'];
    winnersLimit = json['winnersLimit'];
    membersCount = json['membersCount'];
    winnersCount = json['winnersCount'];
    coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    channel = json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    creator = json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    if (json['winners'] != null) {
      winners = [];
      json['winners'].forEach((v) {
        winners?.add(Winners.fromJson(v));
      });
    }
    socialMedia = json['socialMedia'];
    createdAt = json['createdAt'];
    finishedAt = json['finishedAt'];
    expirationTime = json['expirationTime'];
  }
  int? id;
  bool? isActive;
  bool? isCanceled;
  bool? isWinnersAwarded;
  int? reward;
  String? rocketChannelId;
  int? winnersLimit;
  int? membersCount;
  int? winnersCount;
  Coin? coin;
  Channel? channel;
  Creator? creator;
  List<Winners>? winners;
  int? socialMedia;
  String? createdAt;
  String? finishedAt;
  String? expirationTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['isActive'] = isActive;
    map['isCanceled'] = isCanceled;
    map['isWinnersAwarded'] = isWinnersAwarded;
    map['reward'] = reward;
    map['rocketChannelId'] = rocketChannelId;
    map['winnersLimit'] = winnersLimit;
    map['membersCount'] = membersCount;
    map['winnersCount'] = winnersCount;
    if (coin != null) {
      map['coin'] = coin?.toJson();
    }
    if (channel != null) {
      map['channel'] = channel?.toJson();
    }
    if (creator != null) {
      map['creator'] = creator?.toJson();
    }
    if (winners != null) {
      map['winners'] = winners?.map((v) => v.toJson()).toList();
    }
    map['socialMedia'] = socialMedia;
    map['createdAt'] = createdAt;
    map['finishedAt'] = finishedAt;
    map['expirationTime'] = expirationTime;
    return map;
  }

}