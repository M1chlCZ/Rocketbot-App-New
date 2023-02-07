import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/NetInterface/interface.dart';

final networkProvider = Provider<NetInterface>((ref) {
  final cm = NetInterface();
  return cm;
});