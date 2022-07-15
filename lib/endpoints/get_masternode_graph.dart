import 'package:intl/intl.dart';
import 'package:rocketbot/models/masternode_data.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/support/utils.dart';

class MasternodeList {
  final NetInterface _interface = NetInterface();

  Future<MasternodeData> getStakingData(int coinID, int type) async {
    Map<String, dynamic> m = {
      "idCoin": coinID,
      "type": type,
      "datetime": type == 1 ? DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()) : Utils.getUTC()
    };
    var rs = await _interface.post("masternode/list", m, pos: true);
    MasternodeData st = MasternodeData.fromJson(rs);
    return st;
  }
}