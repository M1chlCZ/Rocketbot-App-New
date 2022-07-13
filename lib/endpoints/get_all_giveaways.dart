import 'package:rocketbot/models/giveaways.dart';
import 'package:rocketbot/netinterface/interface.dart';

class GiveawaysList {
  final NetInterface _helper = NetInterface();

  Future<List<Giveaway>?> fetchGiveaways(int page) async {
    List<Giveaway>? m = [];
    Map<String, dynamic> responseG = await _helper.get("Games/ActiveGiveaways?Page=$page&PageSize=100");
    List<Giveaway>? g = Giveaways.fromJson(responseG).data;
    if(g != null && g.isNotEmpty) m.addAll(g);
    return m;
  }
}