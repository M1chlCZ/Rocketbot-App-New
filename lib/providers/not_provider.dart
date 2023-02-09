import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/models/notifications.dart';
import 'package:rocketbot/providers/db_provider.dart';

final notificationProvider = FutureProvider<List<NotNode>>((ref) async {
  try {
    final db = ref.read(dbProvider);
    return await db.getNotifications();
  } catch (e) {
    print(e);
    return [];
  }
});