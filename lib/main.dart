import 'dart:io';

import 'package:fire_alarm_app/app.dart';
import 'package:fire_alarm_app/bootstrap.dart';
import 'package:fire_alarm_app/configs/enums.dart';
import 'package:fire_alarm_app/firebase_options.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initNotifications();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  bootstrap(env: AppEnvironment.DEVELOPMENT, builder: () => FireAlarmApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> initNotifications() async {
  // Yêu cầu quyền thông báo
  await FirebaseMessaging.instance.requestPermission(
    provisional: true,
    alert: true,
    badge: true,
    sound: true,
  );

  String? token;

  if (Platform.isIOS) {
    token = await FirebaseMessaging.instance.getAPNSToken();
  } else if (Platform.isAndroid) {
    token = await FirebaseMessaging.instance.getToken();
  }

  if (token != null) {
    Common.printLog("Token là: $token");
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {}).onError((err) {
    print("Lỗi khi cập nhật token: $err");
  });
}
