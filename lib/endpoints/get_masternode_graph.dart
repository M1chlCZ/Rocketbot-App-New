import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:intl/intl.dart';
import 'package:rocketbot/models/masternode_data.dart';
import 'package:rocketbot/netinterface/interface.dart';

class MasternodeList {
  final RocketbotClient _interface = RocketbotClient();

  Future<MasternodeData> getStakingData(int coinID, int type) async {
    Map<String, dynamic> m = {
      "idCoin": coinID,
      "type": type,
      "datetime": type == 1 ? DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()) : DateFormats.utcDayStart()
    };
    var rs = await _interface.post("masternode/list", m, pos: true);
    MasternodeData st = MasternodeData.fromJson(rs);
    return st;
  }
}