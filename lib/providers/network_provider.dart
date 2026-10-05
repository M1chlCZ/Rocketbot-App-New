import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/netinterface/interface.dart';

final networkProvider = Provider<RocketbotClient>((ref) {
  final cm = RocketbotClient();
  return cm;
});