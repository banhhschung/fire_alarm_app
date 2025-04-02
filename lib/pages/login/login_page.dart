import 'dart:io';

import 'package:fire_alarm_app/blocs/account_bloc/account_bloc.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_event.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_state.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/model/login_data_model.dart';
import 'package:fire_alarm_app/pages/verify_otp/verify_otp_page.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/utils/shared_preferences.dart';
import 'package:fire_alarm_app/utils/shared_preferences_keys.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  var _isLogin = true;
  bool isPasswordLengthOk = false;
  bool isPasswordFormatOk = false;

  final TextEditingController _createUserNameController = TextEditingController();
  final TextEditingController _createPhoneOrEmailController = TextEditingController();
  final TextEditingController _createPasswordController = TextEditingController();
  final TextEditingController _createConfirmPasswordController = TextEditingController();


  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AccountBloc _accountBloc;
  LoginData? loginData;

  String? _deviceToken;
  bool _isShowProcess = false;

  RegisterAccountModel _registerAccountModel = RegisterAccountModel();


  @override
  void initState() {
    getDeviceToken();
    _accountBloc = AccountBloc();
    super.initState();
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(child: _mainLoginWidget()),
    );
  }

  Widget _mainLoginWidget() {
    return BlocListener<AccountBloc, AccountState>(
      bloc: _accountBloc,
      listener: (BuildContext context, AccountState state) {
        if (state is LoginConnectError) {
          _toggleProcess(false);
          Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
        }
        /*else if (state is GetLoginInfoOnSfUtilCompleteState) {
          _toggleProcess(false);
        } else if (state is GetLoginInfoOnSfUtilState) {
          if (state.provider != null && (ConfigApp.PROVIDER_LOGIN_PHONE_TYPE == state.provider || ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE == state.provider)) {
            if (state.providerUserId != null) {
              _userNameController.text = state.providerUserId!;
              _passwordController.text = state.password!;
            }
            setState(() {});
          }
          _toggleProcess(false);
        }*/ else if (state is AccountWasExistedState) {
          if (_isLogin) {
            _accountBloc.add(SubmittedLoginAccountEvent(loginData));
          }else{
            _toggleProcess(false);
            if (state.provider == ConfigApp.PROVIDER_LOGIN_PHONE_TYPE) {
              Common.showSnackBarMessage(context, S.current.phone_number_was_registered, isError: true);
            } else {
              Common.showSnackBarMessage(context, S.current.email_was_registered, isError: true);
            }
          }
        } else if (state is AccountNotExistedState) {
          _toggleProcess(false);
          if(_isLogin){
            if (state.provider == ConfigApp.PROVIDER_LOGIN_PHONE_TYPE) {
              Common.showSnackBarMessage(context, S.current.phone_not_registered_warning, isError: true);
            } else {
              Common.showSnackBarMessage(context, S.current.email_not_registered_warning, isError: true);
            }
          } else{
            _accountBloc.add(RegisterAccountEvent(registerAccountModel: _registerAccountModel));
          }
        }
        if (state is LoginWrongUsernameOrPassword) {
          _toggleProcess(false);
          Common.showSnackBarMessage(context, S.current.wrong_login_information, isError: true);
        } else if (state is LoginFailure) {
          _toggleProcess(false);
          Common.showSnackBarMessage(context, S.current.login_failed_please_try_again, isError: true);
        } else if (state is LoginSuccessful) {
          _toggleProcess(false);
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.tabBarPage, (_) => false);
          });
        } else if (state is RegisterAccountSystemErrorState) {
          _toggleProcess(false);
          Common.showSnackBarMessage(context, S.current.failed_please_try_again, isError: true);
        } else if (state is RegisterAccountSentSMSLimitState) {
          _toggleProcess(false);
          Common.showSnackBarMessage(context, S.current.sent_sms_limit, isError: true);
        } else if (state is RegisterAccountSuccessfulState) {
          _toggleProcess(false);
          Navigator.of(context).pushNamed(AppRoutes.verifyOTPPage, arguments: VerifyCodeArgs(registerAccountModel: _registerAccountModel, deviceToken: _deviceToken));
        }

      },
      child: Column(
        children: [_headerLoginLayout(), (_isLogin) ? _contentLoginLayout() : _contentRegisterLayout()],
      ),
    );
  }

  Widget _headerLoginLayout() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [


        Assets.images.backgroundLogin.image(),
        Positioned(
          left: 16,
          child: Text(
            (_isLogin) ? S.current.login : S.current.register,
            style: AppFonts.titleHeaderBold(),
          ),
        )
      ],
    );
  }

  Widget _contentLoginLayout() {
    return Expanded(
      child: Container(
        color: AppColors.orangee,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSize.a16), topRight: Radius.circular(AppSize.a16))),
          child: Padding(
            padding: const EdgeInsets.only(left: AppPadding.p16, right: AppPadding.p16, top: AppPadding.p40),
            child: Column(
              children: [
                CustomTextFieldWidget(
                  titleInput: '${S.current.phone_number} / ${S.current.email}',
                  hintText: S.current.enter_phone_number_or_email,
                  controller: _userNameController,
                ),
                const SizedBox(
                  height: AppPadding.p16,
                ),
                CustomTextFieldWidget(
                  titleInput: S.current.password,
                  hintText: S.current.enter_password,
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: AppPadding.p16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _savePasswordLayout(),
                    Text(
                      S.current.forgot_pass,
                      style: AppFonts.title(color: AppColors.orangee),
                    )
                  ],
                ),
                const SizedBox(
                  height: AppPadding.p34,
                ),
                HighLightButton(
                  title: S.current.login,
                  onPress: () {
                    _doLogin();
                  },
                ),
                const SizedBox(
                  height: AppSize.a35,
                ),
                _anotherLoginTextLayout()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contentRegisterLayout() {
    RegExp passwordFormatRegex = RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+");

    return Expanded(
      child: Container(
        color: AppColors.orangee,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSize.a16), topRight: Radius.circular(AppSize.a16))),
          child: Padding(
            padding: const EdgeInsets.only(left: AppPadding.p16, right: AppPadding.p16, top: AppPadding.p40),
            child: Column(
              children: [
                CustomTextFieldWidget(
                  titleInput: S.current.full_name,
                  hintText: S.current.enter_your_full_name,
                  controller: _createUserNameController,
                ),
                const SizedBox(
                  height: AppPadding.p16,
                ),
                CustomTextFieldWidget(
                  titleInput: '${S.current.phone_number} / ${S.current.email}',
                  hintText: S.current.enter_phone_number_or_email,
                  controller: _createPhoneOrEmailController,
                  onChanged: (value) {

                  },
                ),
                const SizedBox(
                  height: AppPadding.p16,
                ),
                CustomTextFieldWidget(
                  titleInput: S.current.password,
                  hintText: S.current.enter_password,
                  isPassword: true,
                  controller: _createPasswordController,
                  onChanged: (value) {
                    if (passwordFormatRegex.hasMatch(value)) {
                      setState(() {
                        isPasswordFormatOk = true;
                      });
                    } else {
                      setState(() {
                        isPasswordFormatOk = false;
                      });
                    }
                    if (value.length >= 6 &&
                        value.length <= 12 &&
                        !value.contains(' ')) {
                      setState(() {
                        isPasswordLengthOk = true;
                      });
                    } else {
                      setState(() {
                        isPasswordLengthOk = false;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: AppPadding.p16,
                ),
                _checkPasswordFormatLayout(),
                const SizedBox(
                  height: AppPadding.p16,
                ),
                CustomTextFieldWidget(
                  titleInput: S.current.enter_password_again,
                  hintText: S.current.enter_password_again,
                  isPassword: true,
                  controller: _createConfirmPasswordController,
                ),
                const SizedBox(
                  height: AppPadding.p16,
                ),
                const SizedBox(
                  height: AppPadding.p34,
                ),
                HighLightButton(
                  title: S.current.register,
                  onPress: () {
                    _doRegister(context);
                  },
                ),
                const SizedBox(
                  height: AppSize.a35,
                ),
                _anotherLoginTextLayout()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkPasswordFormatLayout() {
    Color lengthColor = isPasswordLengthOk ? AppColors.successPrimary : AppColors.primaryText;
    Color formatColor = isPasswordFormatOk ? AppColors.successPrimary : AppColors.primaryText;

    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.done,
              size: AppSize.a12,
              color: lengthColor,
            ),
            const SizedBox(
              width: AppSize.a4,
            ),
            Text(
              S.current.password_length_requite,
              style: AppFonts.normalText(fontSize: AppSize.a12, color: lengthColor),
            )
          ],
        ),
        const SizedBox(
          height: AppSize.a4,
        ),
        Row(
          children: [
            Icon(
              Icons.done,
              size: AppSize.a12,
              color: formatColor,
            ),
            const SizedBox(
              width: AppSize.a4,
            ),
            Text(
              S.current.password_capital_letters_requite,
              style: AppFonts.normalText(fontSize: AppSize.a12, color: formatColor),
            )
          ],
        )
      ],
    );
  }

  Widget _savePasswordLayout() {
    return Row(
      children: [
        Container(
          width: AppSize.a16,
          height: AppSize.a16,
          decoration: BoxDecoration(border: Border.all(width: AppPadding.p1_5, color: AppColors.backgroundGrey)),
        ),
        const SizedBox(
          width: AppSize.a10,
        ),
        Text(
          S.current.save_password,
          style: AppFonts.title(color: AppColors.primaryText),
        )
      ],
    );
  }

  Widget _anotherLoginTextLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? S.current.you_not_have_account : S.current.you_have_account,
          style: AppFonts.normalText(),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            child: Text(
              _isLogin ? S.current.register : S.current.login,
              style: AppFonts.normalText(color: AppColors.orangee),
            ),
          ),
        )
      ],
    );
  }

  _doLogin() async {
    _isLogin = true;
    var userName = _userNameController.text;
    var pass = _passwordController.text;

    if (_deviceToken == null) {
      await getDeviceToken();
    }

    SpUtil? spUtil = await SpUtil.getInstance();
    String? lang = spUtil!.getString(SharedPreferencesKeys.language);

    if (userName.isEmpty || pass.isEmpty) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.login_text_empty_warning, isError: true);
    } else if (!Common.checkValidEmail(userName) && !Common.checkValidPhoneNumber(userName)) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.email_phone_invalid_warning, isError: true);
    } else if (Common.checkValidEmail(userName)) {
      loginData = LoginData(
        provider: ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE,
        providerUserId: userName,
        password: pass,
        osSystem: getOs(),
        deviceToken: _deviceToken,
        language: lang != null ? (lang == 'vi' ? 1 : 2) : 1,
      );
      _accountBloc.add(CheckAccountIsExistedAccountEvent(loginData!.provider, loginData!.providerUserId));
    } else if (Common.checkValidPhoneNumber(userName)) {
      loginData = LoginData(
        provider: ConfigApp.PROVIDER_LOGIN_PHONE_TYPE,
        providerUserId: userName,
        password: pass,
        osSystem: getOs(),
        deviceToken: _deviceToken,
        language: lang != null ? (lang == 'vi' ? 1 : 2) : 1,
      );
      _accountBloc.add(CheckAccountIsExistedAccountEvent(loginData!.provider, loginData!.providerUserId));
    }
  }

  int getOs() {
    if (Platform.isIOS) {
      return 1;
    } else if (Platform.isAndroid) {
      return 0;
    }
    return -1;
  }

  void _doRegister(BuildContext context) {
    _isLogin = false;
    var fullName = _createUserNameController.text;

    var userName = _createPhoneOrEmailController.text;
    var password = _createPasswordController.text;
    var confirmPassword = _createConfirmPasswordController.text;

    ProviderMetadata providerMetadata = ProviderMetadata();

    if (fullName.isEmpty) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.name_empty, isError: true);
    } else if (userName!.isEmpty) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.email_phone_empty, isError: true);
    } else if (password!.isEmpty) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.password_empty, isError: true);
    } else if (isHaveVnChar(userName)) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.email_phone_wrong_format, isError: true);
    } else if (password!.contains(' ') || Common.checkStringHasEmoji(password!)) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.wrong_password_format, isError: true);
    } else if (password!.length < 6 || password!.length > 12 || isHaveVnChar(password) || password!.contains(' ')) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.wrong_password_format, isError: true);
    } else if (confirmPassword.isEmpty) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.confirm_password_empty, isError: true);
    } else if (!Common.checkValidEmail(userName!) && !Common.checkValidPhoneNumber(userName!)) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.email_phone_wrong_format, isError: true);
    } else if (confirmPassword != password) {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.not_matched_password, isError: true);
    } else {
      _toggleProcess(true);
      userName!.trim();
      if (Common.checkValidEmail(userName!)) {
        _registerAccountModel.provider = ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE;
        _registerAccountModel.providerUserId = userName;
        _registerAccountModel.password = password;
        providerMetadata.name = fullName;
        _registerAccountModel.providerMetadata = providerMetadataToJson(providerMetadata);
        _accountBloc.add(CheckAccountIsExistedAccountEvent(_registerAccountModel.provider, _registerAccountModel.providerUserId));
      } else if (Common.checkValidPhoneNumber(userName!)) {
        _registerAccountModel.provider = ConfigApp.PROVIDER_LOGIN_PHONE_TYPE;
        _registerAccountModel.providerUserId = userName;
        _registerAccountModel.password = password;
        providerMetadata.name = fullName;
        _registerAccountModel.providerMetadata = providerMetadataToJson(providerMetadata);
        _accountBloc.add(CheckAccountIsExistedAccountEvent(_registerAccountModel.provider, _registerAccountModel.providerUserId));
      } else {}
    }
  }

  bool isHaveVnChar(String? value) {
    for (String index in Common.SOURCE_CHARACTERS) {
      if (value!.contains(index)) {
        return true;
      }
    }
    return false;
  }

  String getPhoneNumber(String phone) {
    if (phone.startsWith('+84')) {
      return phone;
    }
    if (phone.startsWith('84')) {
      return '+$phone';
    }
    return '+84${phone.substring(1, phone.length)}';
  }

  Future<String?> getDeviceToken() async {
    if (Platform.isIOS) await iOSPermission();

    try {
      _deviceToken = await _firebaseMessaging.getToken().timeout(Duration(seconds: 3));
      Common.printLog('token: $_deviceToken');
      return _deviceToken;
    } catch (e) {
      return _deviceToken;
    }

  }

  Future<void> iOSPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
