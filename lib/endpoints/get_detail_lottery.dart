
import 'package:rocketbot/models/lottery_details.dart';
import 'package:rocketbot/netinterface/interface.dart';

class LotteryDetail {
  final NetInterface _helper = NetInterface();

  Future<Map<String, dynamic>?> fetchLottery(int id) async {
    var s = await _helper.get("Games/GetSpinLottery", request: "id=$id", debug: false);
    LotteryDetailsData? activeAirdrop = LotteryDetails.fromJson(s).data!;
    Map<String, dynamic> m = {"activeLottery": activeAirdrop, "members": null};
    return m;
  }
}
