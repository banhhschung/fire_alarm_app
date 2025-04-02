import 'dart:async';

import 'package:fire_alarm_app/blocs/account_bloc/account_bloc.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_event.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/utils/shared_preferences.dart';
import 'package:fire_alarm_app/utils/shared_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLogged(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("splash screen"),
    );
  }

  void _checkLogged(BuildContext context) {
    SpUtil.getInstance().then((spUtil) {
      int? accountId = spUtil!.getInt(SharedPreferencesKeys.currentAccountId);
      if (accountId != null) {
        BlocProvider.of<AccountBloc>(context).add(RefreshAccountTokenAccountEvent());
      } else {
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.loginPage,
          );
        });
      }
    });
  }
}
