import 'package:rocketbot/models/airdrops.dart';
import 'package:rocketbot/netInterface/interface.dart';

class AirdropList {
  final NetInterface _helper = NetInterface();

  Future<List<Airdrop>?> fetchAirdrops() async {
    List<Airdrop>? m = [];
    Map<String, dynamic> responseG = await _helper.get("Games/ActiveAirdrops?Page=1&PageSize=100");
    List<Airdrop>? g = Airdrops.fromJson(responseG).data;
    if(g != null && g.isNotEmpty) m.addAll(g);
    return m;
  }
}