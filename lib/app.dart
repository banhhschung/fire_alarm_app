
import 'package:fire_alarm_app/blocs/account_bloc/account_bloc.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_state.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_event.dart';
import 'package:fire_alarm_app/blocs/udp_bloc/udp_bloc.dart';
import 'package:fire_alarm_app/blocs/udp_bloc/udp_event.dart';
import 'package:fire_alarm_app/commons/extension.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class FireAlarmApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FireAlarmAppState();
}

class _FireAlarmAppState extends State<FireAlarmApp> with WidgetsBindingObserver{
  final navigatorKey = GlobalKey<NavigatorState>();

  late AccountBloc _accountBloc;
  late MqttBloc _mqttBloc;
  late UdpBloc _udpBloc;

  @override
  void initState() {
    _initBloc();
    super.initState();
  }

  void _initBloc() {
    _accountBloc = AccountBloc();
    _udpBloc = UdpBloc()..add(StartConnectUdpEvent());
    _mqttBloc = MqttBloc(_udpBloc);
    _mqttBloc.add(StartConnectMqttEvent());
    // _firebaseCloudMessagingListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _mqttBloc.add(DisconnectMqttEvent());
      _udpBloc.add(CloseConnectUdpEvent());
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.resumed) {
      _mqttBloc.add(RefreshConnectMqttEvent());
      _udpBloc.add(StartConnectUdpEvent());
      /*_refreshTokenBloc
          .add(RefreshToken(DateTime.now().millisecondsSinceEpoch));

      Future.delayed(AppConstant.duration3s).then((value) {
        _globalNotificationBloc.add(GlobalRefreshStateDeviceEvent());

        Future.delayed(AppConstant.duration1s).then((value) {
          _globalNotificationBloc.add(GlobalUpdateDeviceStatusEvent());
        });
      });*/
    }
    super.didChangeAppLifecycleState(state);
  }


  @override
  void dispose() {
    _mqttBloc.close();
    _udpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AccountBloc>(create: (context) => _accountBloc, lazy: true),
          BlocProvider<MqttBloc>(create: (context) => _mqttBloc, lazy: true,),
          BlocProvider<UdpBloc>(create: (context) => _udpBloc, lazy: true,),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<AccountBloc, AccountState>(
                listener: (_, state){
                  if(state is AuthenticatedSuccessState){
                    if(navigatorKey.currentState != null){
                      navigatorKey.currentState?.pushNamedAndRemoveUntil(AppRoutes.tabBarPage, (_) => false);
                    }
                  } else if(state is UnAuthenticatedState){
                    GlobaleExtensions.fistScheduleRender(() {
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginPage, (_) => false);
                    });
                  }
                },
            )
          ],
          child: _app(),
        ));
  }

  Widget _app(){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Báo cháy báo khói',
      navigatorKey: navigatorKey,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splashPage,

      locale: Locale('vi'),
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}