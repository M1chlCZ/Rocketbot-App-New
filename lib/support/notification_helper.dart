import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/support/secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    final notification = message.data['notification'];
  }
  print("shit");
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final NetInterface _interface  = NetInterface();
  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() async {
    // print("///////////");
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(
          (message) async {
        if (message.data.containsKey('data')) {
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          streamCtlr.sink.add(message.data['notification']);
        }
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data.keys.first == 'link') {
        try {
          launchUrl(Uri.parse(message.data["dataLink"]), mode: LaunchMode.externalNonBrowserApplication);
        } catch (e) {
          try {
            launchUrl(Uri.parse(message.data["dataLink"]), mode: LaunchMode.externalApplication);
          } catch (e) {
            launchUrl(Uri.parse(message.data["dataLink"]), mode: LaunchMode.platformDefault);
          }
          debugPrint(e.toString());
        }
      }
    });
    final token = await _firebaseMessaging.getToken();
    if(token != null) {
      _tokenUpload(token);
      SecureStorage.writeStorage(key: 'firebase_token', value: token);
    }
  }

  onNotificationRegister() {
    FirebaseMessaging.onMessage.listen(
          (message) async {
        if (message.data.containsKey('data')) {
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          streamCtlr.sink.add(message.data['notification']);
        }
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );
  }

  void _tokenUpload(String? token) {
    Map <String, dynamic> req = {
      "token" : token,
    };
    _interface.post('Security/UpdateFirebaseToken', req);
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}