
import 'package:rocketbot/models/aidrop_details.dart';
import 'package:rocketbot/netinterface/interface.dart';

class AirdropDetail {
  final NetInterface _helper = NetInterface();

  Future<Map<String, dynamic>?> fetchAirdrop(int id) async {
    var s = await _helper.get("Games/Airdrop", request: "id=$id", debug: false);
    AirdropData? activeAirdrop = AirdropDetails.fromJson(s).data!;
    Map<String, dynamic> m = {"activeAirdrop": activeAirdrop, "members": null};
    return m;
  }
}
