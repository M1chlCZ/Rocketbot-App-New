import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/models/deposit_address.dart';
import 'package:rocketbot/providers/network_provider.dart';

final depAddressProvider = FutureProvider.family<String?, int>((ref, idCoin) async {
  try {
    var request = <String, dynamic> {
      "coinId": idCoin,
    };
    dynamic response = await ref.read(networkProvider).post("Transfers/CreateDepositAddress", request, debug: false);
    var d = DepositAddress.fromJson(response);
   return d.data!.address!;
  } catch (e) {
    print(e);
    return null;
  }
});