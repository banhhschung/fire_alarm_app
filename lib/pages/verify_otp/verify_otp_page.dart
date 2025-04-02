import 'dart:async';
import 'dart:io';

import 'package:fire_alarm_app/blocs/account_bloc/account_bloc.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_event.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_state.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/model/login_data_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_pin_code_text_field/custom_pin_code_text_field.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ErrorOtpStatus {
  none,
  otpExpire,
  otpWrong,
}

class VerifyOtpPage extends StatefulWidget {
  final VerifyCodeArgs verifyCodeArgs;

  const VerifyOtpPage({super.key, required this.verifyCodeArgs});

  @override
  State<StatefulWidget> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late AccountBloc _accountBloc;
  late VerifyCodeArgs _verifyCodeArgs;
  late RegisterAccountModel _registerAccountModel;
  late String? _deviceToken;

  int _timeCountDown = 90;
  Timer? _timer;
  bool _isShowProcess = false;

  late ErrorOtpStatus _otpErrorStatus = ErrorOtpStatus.none;

  @override
  void initState() {
    _accountBloc = AccountBloc();
    _verifyCodeArgs = widget.verifyCodeArgs;
    _registerAccountModel = _verifyCodeArgs.registerAccountModel!;
    _deviceToken = widget.verifyCodeArgs.deviceToken;
    _startCountdown();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: S.current.confirm_otp,
          isShowBackButton: false,
          backgroundColor: AppColors.orangee,
        ),
        body: BlocListener<AccountBloc, AccountState>(
            bloc: _accountBloc,
            listener: (context, state) {
              _toggleProcess(false);
              if (state is AccountSendOTPCodeSuccessState) {
                Common.showSnackBarMessage(
                  context,
                  "Success",
                );
                _toggleProcess(true);
                LoginData loginData = LoginData(
                  provider: _registerAccountModel.provider,
                  providerUserId: _registerAccountModel.providerUserId,
                  password: _registerAccountModel.password,
                  osSystem: getOs(),
                  deviceToken: _deviceToken,
                  language: 1,
                );
                _accountBloc.add(SubmittedLoginAccountEvent(loginData));

              } else if (state is AccountSendOTPWrongCodeState) {
                setState(() {
                  _otpErrorStatus = ErrorOtpStatus.otpWrong;
                });
                Common.showSnackBarMessage(context, S.current.OTP_code_is_incorrect, isError: true);
              } else if (state is AccountSendOTPCodeFailState) {
                setState(() {
                  _otpErrorStatus = ErrorOtpStatus.otpWrong;
                });
                Common.showSnackBarMessage(context, "Error", isError: true);
              } else if (state is RegisterAccountSuccessfulState) {
                setState(() {
                  _otpErrorStatus = ErrorOtpStatus.none;
                });
                _startCountdown();
              } else if (state is LoginSuccessful) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.tabBarPage, (_) => false);
                });
              }
            },
            child: _buildVerifyOtpPageLayout()));
  }

  Widget _buildVerifyOtpPageLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p40),
              child: Assets.images.otpIc.image(width: 110, height: 110),
            ),
            _buildSendVerifyCodeToUserNumberTextLayout(),
            const SizedBox(
              height: AppSize.a30,
            ),
            CustomPinCodeTextField(
              pinBoxHeight: AppSize.a40,
              pinBoxWidth: AppSize.a40,
              pinTextStyle: AppFonts.title(),
              onDone: (value) {
                _sendConfirmOTPFunction(value);
              },
            ),
            const SizedBox(
              height: AppSize.a24,
            ),
            _otpTimeRemainingLayout(),
            const SizedBox(
              height: AppSize.a18,
            ),
            _sendOTPAgainLayout()
          ],
        ),
      ),
    );
  }

  Widget _otpTimeRemainingLayout() {
    if (_otpErrorStatus == ErrorOtpStatus.otpExpire) {
      return Text(
        S.current.OTP_code_has_expired,
        style: AppFonts.title(color: AppColors.orangee),
      );
    } else {
      return RichText(
        text: TextSpan(
            text: "${S.current.OTP_code_expires_after} ",
            style: AppFonts.title(),
            children: [TextSpan(text: "$_timeCountDown ${S.current.second}", style: AppFonts.title(color: AppColors.orangee))]),
      );
    }
  }

  Widget _sendOTPAgainLayout() {
    return GestureDetector(
      onTap: (){
        if(_otpErrorStatus == ErrorOtpStatus.otpExpire){
          _resendOTPCodeFunction();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Text(
        S.current.send_back,
        style: AppFonts.buttonText(color: _otpErrorStatus == ErrorOtpStatus.otpExpire ? AppColors.title : AppColors.secondaryText),
      ),
    );
  }

  void _startCountdown() {
    _timer?.cancel();
    _timeCountDown = 90;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeCountDown > 0) {
          _timeCountDown--;
        } else {
          timer.cancel();
          setState(() {
            _otpErrorStatus = ErrorOtpStatus.otpExpire;
          });
        }
      });
    });
  }

  Widget _buildSendVerifyCodeToUserNumberTextLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p46),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(text: "${S.current.please_enter_the_code_we_sent_you_via_phone_number} ", style: AppFonts.title6()),
          TextSpan(text: _registerAccountModel.providerUserId ?? "", style: AppFonts.title5()),
        ]),
      ),
    );
  }

  Future<void> _sendConfirmOTPFunction(String otp) async {
    _toggleProcess(true);
    if (await Common.isConnectToServer()) {
      if (_deviceToken != null) {
        await firebaseCloudMessagingListeners();
      }
      if (_timeCountDown == 0) {
        _toggleProcess(false);
        setState(() {
          _otpErrorStatus == ErrorOtpStatus.otpExpire;
        });
      } else {
        _accountBloc
            .add(AccountSendOTPCodeEvent(providerUserId: _registerAccountModel.providerUserId!, provider: _registerAccountModel.provider!, activeCode: otp));
      }
    } else {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
    }
  }

  void _resendOTPCodeFunction() async {
    _toggleProcess(true);
    if (await Common.isConnectToServer()) {
      _accountBloc.add(RegisterAccountEvent(registerAccountModel: _registerAccountModel));
    } else {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
    }
  }

  Future<String> firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) await iOSPermission();
    try {
      _deviceToken = await _firebaseMessaging.getToken().timeout(const Duration(seconds: 3));
      return _deviceToken!;
    } catch (e) {
      return _deviceToken!;
    }
  }

  Future<void> iOSPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  int getOs() {
    if (Platform.isIOS) {
      return 1;
    } else if (Platform.isAndroid) {
      return 0;
    }
    return -1;
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}

class VerifyCodeArgs {
  final RegisterAccountModel? registerAccountModel;
  final String? verificationId;
  final String? deviceToken;

  VerifyCodeArgs({this.registerAccountModel, this.verificationId, this.deviceToken});
}
