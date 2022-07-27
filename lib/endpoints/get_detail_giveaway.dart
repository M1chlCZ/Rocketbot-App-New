import 'package:rocketbot/models/active_giveaways.dart';
import 'package:rocketbot/models/giveaway_members.dart';
import 'package:rocketbot/models/twitter_giveaway.dart';
import 'package:rocketbot/netinterface/interface.dart';

class GiveawayDetail {
  final NetInterface _helper = NetInterface();

  Future<Map<String, dynamic>?> fetchGiveaways(int id, int socialNetwork) async {
    if (socialNetwork != 3) {
      var s = await _helper.get("Games/Giveaway", request: "id=$id");
      ActiveGiveaway? activeGiveaway = ActiveGiveaways.fromJson(s).data!;
      var d = await _helper.get("Games/GiveawayMembers", request: "Id=$id&Page=1&PageSize=500");
      List<Members>? giveawayMembers = GiveawayMembers.fromJson(d).data;
      Map<String, dynamic> m = {"activeGiveaway": activeGiveaway, "members": giveawayMembers};
      return m;
    } else {
      var t = await _helper.get("Games/TwitterGiveaway", request: "id=$id");
      TwitterGiveaway? twitterGiveaway = TwitterGiveaways.fromJson(t).data!;
      var d = await _helper.get("Games/GiveawayMembers", request: "Id=$id&Page=1&PageSize=500");
      List<Members>? giveawayMembers = GiveawayMembers.fromJson(d).data;
      Map<String, dynamic> m = {"twitterGiveaway": twitterGiveaway, "members": giveawayMembers};
      return m;
    }
  }
}
