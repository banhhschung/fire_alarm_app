
import 'package:fire_alarm_app/pages/login/login_page.dart';
import 'package:flutter/material.dart';

class FireAlarmApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FireAlarmAppState();
}

class _FireAlarmAppState extends State<FireAlarmApp>{
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }

  Widget _app(){
    return MaterialApp(

    );
  }
}