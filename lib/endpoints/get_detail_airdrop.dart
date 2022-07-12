import 'package:rocketbot/models/active_giveaways.dart';
import 'package:rocketbot/models/giveaway_members.dart';
import 'package:rocketbot/netInterface/interface.dart';

class AirdropDetail {
  final NetInterface _helper = NetInterface();

  Future<Map<String, dynamic>?> fetchAirdrop(int id) async {
    var s = await _helper.get("Games/Airdrop", request: "id=$id");
    ActiveGiveaway? activeGiveaway = ActiveGiveaways.fromJson(s).data!;
    // var d = await _helper.get("Games/GiveawayMembers", request: "Id=$id&Page=1&PageSize=500");
    // List<Members>? giveawayMembers = GiveawayMembers.fromJson(d).data;
    Map<String, dynamic> m = {"activeGiveaway": activeGiveaway, "members": null};
    return m;
  }
}
