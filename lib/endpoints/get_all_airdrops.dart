import 'package:rocketbot/models/airdrops.dart';
import 'package:rocketbot/netinterface/interface.dart';

class AirdropList {
  final NetInterface _helper = NetInterface();

  Future<List<Airdrop>?> fetchAirdrops(int page) async {
    List<Airdrop>? m = [];
    Map<String, dynamic> responseG = await _helper.get("Games/ActiveAirdrops?Page=$page&PageSize=100");
    List<Airdrop>? g = Airdrops.fromJson(responseG).data;
    if(g != null && g.isNotEmpty) m.addAll(g);
    return m;
  }
}