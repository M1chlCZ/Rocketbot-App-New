import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/storage/app_database.dart';

final dbProvider = Provider<AppDatabase>((ref) {
  final cm = AppDatabase();
  return cm;
});