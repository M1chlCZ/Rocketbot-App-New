import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/models/aidrop_details.dart';
import 'package:rocketbot/providers/network_provider.dart';

final airdropProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, id) async {
  try {
    var s = await ref.read(networkProvider).get("Games/Airdrop", request: "id=$id", debug: true);
    AirdropData? activeAirdrop = AirdropDetails.fromJson(s).data!;
    Map<String, dynamic> m = {"activeAirdrop": activeAirdrop, "members": null};
    return m;
  } catch (e) {
    print(e);
    return {};
  }
});