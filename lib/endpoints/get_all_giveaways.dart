import 'package:rocketbot/models/giveaways.dart';
import 'package:rocketbot/netInterface/interface.dart';

class GiveawaysList {
  final NetInterface _helper = NetInterface();

  Future<List<Giveaway>?> fetchGiveaways() async {
    List<Giveaway>? m = [];
    Map<String, dynamic> responseG = await _helper.get("Games/ActiveGiveaways?Page=1&PageSize=100");
    List<Giveaway>? g = Giveaways.fromJson(responseG).data;
    if(g != null && g.isNotEmpty) m.addAll(g);
    return m;
  }
}