import 'dart:async';


import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/configs/enums.dart';
import 'package:fire_alarm_app/provides/database_provider.dart';
import 'package:fire_alarm_app/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> bootstrap({
  FutureOr<Widget> Function()? builder,
  required AppEnvironment env,
  FutureOr<void> Function()? onInitializeDependencies,
}) async {
  assert(builder != null, 'builder is required');
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (onInitializeDependencies != null) {
    await onInitializeDependencies();
  }

  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  ConfigApp.changeEnv(env);
  await DatabaseHelper.instance.initDatabase();
  await SpUtil.instance;
  //

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(await builder!());
}
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
