
import 'package:rocketbot/models/loterries.dart';
import 'package:rocketbot/netinterface/interface.dart';

class LotteryList {
  final NetInterface _helper = NetInterface();

  Future<List<Lottery>?> fetchLotteries(int page) async {
    List<Lottery>? m = [];
    Map<String, dynamic> responseG = await _helper.get("Games/ActiveSpinLotteries?Page=$page&PageSize=100", debug: true);
    List<Lottery>? g = Lotteries.fromJson(responseG).data;
    if(g != null && g.isNotEmpty) m.addAll(g);
    return m;
  }
}