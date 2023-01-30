import 'package:get_it/get_it.dart';
import 'package:rocketbot/storage/app_database.dart';
import 'package:rocketbot/support/notification_helper.dart';

final getInstance = GetIt.instance;

void getSetup() {
  // AppDatabase().initDb();
  getInstance.registerLazySingleton<AppDatabase>(() => AppDatabase());
  getInstance.registerLazySingleton<FCM>(() => FCM());
}
