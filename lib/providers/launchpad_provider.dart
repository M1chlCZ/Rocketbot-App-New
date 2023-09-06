import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/NetInterface/interface.dart';
import 'package:rocketbot/models/launchpad.dart';
import 'package:rocketbot/models/launchpad_detail.dart';

final launchpadProvider = FutureProvider<LaunchpadMobile>((ref) async {
  try {
    NetInterface net = NetInterface();
    dynamic response = await net.get("/mobile/launchpad/list", launchpad: true,  debug: false);
    var d = LaunchpadMobile.fromJson(response);
    return d;
  } catch (e, st) {
    print(e);
    return Future.error(e, st);
  }
});

final launchpadDetailProvider = FutureProvider.family<LaunchpadMobileDetail, int>((ref, id) async {
  try {
    NetInterface net = NetInterface();
    dynamic response = await net.get("/mobile/launchpad/detail/$id", launchpad: true,  debug: false);
    var d = LaunchpadMobileDetail.fromJson(response);
    return d;
  } catch (e, st) {
    print(e);
    return Future.error(e, st);
  }
});