import 'package:rocketbot/models/airdrops.dart';
import 'package:rocketbot/models/loterries.dart';
import 'package:rocketbot/netInterface/interface.dart';

class LotteryList {
  final NetInterface _helper = NetInterface();

  Future<List<Lottery>?> fetchLotteries() async {
    List<Lottery>? m = [];
    Map<String, dynamic> responseG = await _helper.get("Games/ActiveSpinLotteries?Page=1&PageSize=100");
    List<Lottery>? g = Lotteries.fromJson(responseG).data;
    if(g != null && g.isNotEmpty) m.addAll(g);
    return m;
  }
}