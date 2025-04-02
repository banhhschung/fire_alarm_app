import 'package:fire_alarm_app/blocs/account_bloc/account_bloc.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_event.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_state.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_ratio_button/custom_ratio_button.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const String BUILDING_SETTING = "building_setting";
  static const String FLOOR_SETTING = "floor_setting";
  static const String DEVICE_SETTING = "device_setting";
  static const String SHARE_MANAGEMENT = "share_management";
  final List<LanguageModel> _languageList = [
    LanguageModel(name: 'Tiếng Việt', code: 'vi', countryCode: 'VN'),
    LanguageModel(name: 'English', code: 'en', countryCode: '')
  ];

  late AccountBloc _accountBloc;

  Account? _currentAccountModel;
  late String _currentLanguage = "";

  late bool _isShowProcess = false;

  @override
  void initState() {
    _accountBloc = AccountBloc()..add(GetAccountLoginEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomLoadingWidget(
        showLoading: _isShowProcess,
        child: BlocListener<AccountBloc, AccountState>(
          bloc: _accountBloc,
          listener: (BuildContext context, AccountState state) {
            if (state is GetAccountLoginState) {
              setState(() {
                _currentAccountModel = state.account;
              });
              _accountBloc.add(AccountGetLanguageEvent());
            } else if (state is AccountLogoutSuccessfulState) {
              _toggleShowProcess(false);
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.popAndPushNamed(context, AppRoutes.loginPage);
                /*BlocProvider.of<AuthenticatedBloc>(context).add(LoggoutEvent(DateTime.now().millisecondsSinceEpoch));*/
              });
            } else if (state is AccountLogoutFailedState) {
              _toggleShowProcess(false);
              Common.showSnackBarMessage(context, S.current.failed_please_try_again, isError: true);
            } else if (state is AccountGetLanguageState) {
              setState(() {
                _currentLanguage = state.locale.languageCode;
              });
            } else if (state is AccountChangeLanguageState){
              setState(() {
                _currentLanguage = state.locale.languageCode;
              });
              _toggleShowProcess(false);
            }
          },
          child: _settingMainLayout(),
        ),
      ),
    );
  }

  Widget _settingMainLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Assets.images.backgroundSetting.image(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: AppSize.a88,
                ),
                _userInformationHeaderLayout(),
                const SizedBox(
                  height: AppSize.a40,
                ),
                _settingControlItemLayout(BUILDING_SETTING, S.current.building_management, Assets.images.homeSettingIcon.image()),
                _settingControlItemLayout(FLOOR_SETTING, S.current.floor_room, Assets.images.floorSettingIcon.image()),
                _settingControlItemLayout(DEVICE_SETTING, S.current.device_management, Assets.images.deviceManagerSettingIcon.image()),
                const SizedBox(
                  height: AppSize.a20,
                ),
                _settingControlItemLayout(SHARE_MANAGEMENT, S.current.share_management, Assets.images.shareManagerSettingIcon.image()),
                const SizedBox(
                  height: AppSize.a20,
                ),
                _settingLanguageItemLayout(),
                const SizedBox(
                  height: AppSize.a20,
                ),
                _logoutLayout()
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _userInformationHeaderLayout() {
    return GestureDetector(
      onTap: () {
        if (_currentAccountModel != null) {
          Navigator.of(context).pushNamed(AppRoutes.userDetailPage);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12, vertical: AppPadding.p12),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppSize.a8)),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.backgroundGrey),
              width: AppSize.a64,
              height: AppSize.a64,
              child: const Icon(Icons.person),
            ),
            const SizedBox(
              width: AppSize.a12,
            ),
            Expanded(
                child: Text(
              _currentAccountModel != null ? _currentAccountModel!.name ?? "" : S.current.login,
              style: AppFonts.titleHeaderBold(fontSize: AppSize.a14, color: AppColors.primaryText),
            )),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: AppSize.a24,
            )
          ],
        ),
      ),
    );
  }

  Widget _settingControlItemLayout(String key, String title, Image iconImage) {
    return GestureDetector(
      onTap: () {
        _userHandleSettingOption(key);
      },
      child: Container(
        padding: const EdgeInsets.only(left: AppPadding.p40, bottom: AppPadding.p16),
        child: Row(
          children: [
            Container(
              width: AppSize.a20,
              height: AppSize.a20,
              child: iconImage,
            ),
            const SizedBox(
              width: AppSize.a16,
            ),
            Text(
              title,
              style: AppFonts.titleHeaderBold(fontSize: AppSize.a14, color: AppColors.primaryText),
            )
          ],
        ),
      ),
    );
  }

  Widget _settingLanguageItemLayout() {
    return Container(
      padding: const EdgeInsets.only(left: AppPadding.p40, bottom: AppPadding.p16, right: AppPadding.p16),
      child: Row(
        children: [
          Row(
            children: [
              SizedBox(width: AppSize.a20, height: AppSize.a20, child: Assets.images.languageSettingIcon.image()),
              const SizedBox(
                width: AppSize.a12,
              ),
              Text(
                S.current.language,
                style: AppFonts.titleHeaderBold(fontSize: AppSize.a14, color: AppColors.primaryText),
              ),
            ],
          ),
          const SizedBox(
            width: AppSize.a18,
          ),
          CustomRadioButton(
            value: _checkCurrentUserLanguage(_languageList.first),
            onChanged: (value) {
              _changeUserLanguage(_languageList.first);
            },
            label: "Tiếng việt",
          ),
          const SizedBox(
            width: AppSize.a18,
          ),
          CustomRadioButton(
            value: _checkCurrentUserLanguage(_languageList.last),
            onChanged: (value) {
              _changeUserLanguage(_languageList.last);
            },
            label: "English",
          ),
        ],
      ),
    );
  }

  bool _checkCurrentUserLanguage(LanguageModel languageModel) {
    return languageModel.code == _currentLanguage;
  }

  void _changeUserLanguage(LanguageModel languageModel) {
    Locale locale;
    if (languageModel.countryCode != null) {
      locale = Locale(languageModel.code, languageModel.countryCode);
    } else {
      locale = Locale(languageModel.code);
    }
    _accountBloc.add(AccountChangeLanguageEvent(locale: locale));
    _toggleShowProcess(true);
  }

  Widget _logoutLayout() {
    return GestureDetector(
      onTap: () {
        showLogoutPopup();
      },
      child: Container(
        padding: const EdgeInsets.only(left: AppPadding.p40, bottom: AppPadding.p16, right: AppPadding.p16),
        child: Row(
          children: [
            SizedBox(width: AppSize.a24, height: AppSize.a24, child: Assets.images.logoutSettingIcon.image()),
            const SizedBox(
              width: AppSize.a12,
            ),
            Text(
              S.current.logout,
              style: AppFonts.titleHeaderBold(fontSize: AppSize.a14, color: AppColors.errorPrimary),
            ),
          ],
        ),
      ),
    );
  }

  void _userHandleSettingOption(String key) {
    switch (key) {
      case (BUILDING_SETTING):
        Navigator.of(context).pushNamed(AppRoutes.userBuildingManagementPage);
        break;
      case (FLOOR_SETTING):
        Navigator.of(context).pushNamed(AppRoutes.userFloorManagementPage);
        break;
      case (DEVICE_SETTING):
        Navigator.of(context).pushNamed(AppRoutes.userDeviceManagementPage);
        break;
      case (SHARE_MANAGEMENT):
        Navigator.of(context).pushNamed(AppRoutes.userShareManagementPage);
        break;
    }
  }

  Future<Future> showLogoutPopup() async {
    Dialog alertDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.a18)),
      child: IntrinsicWidth(
        child: Container(
          height: 265,
          width: MediaQuery.of(context).size.width - AppSize.a12,
          decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(AppSize.a18))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: AppSize.a80,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSize.a18), topRight: Radius.circular(AppSize.a18))),
                child: Center(child: Text(S.current.logout, style: AppFonts.titleHeaderBold())),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSize.a16, horizontal: AppSize.a35),
                    child: Text(S.current.do_you_want_to_logout, style: AppFonts.title()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                child: Row(
                  children: [
                    Expanded(
                      child: HighLightButton(
                          onPress: () {
                            Navigator.of(context).pop();
                          },
                          title: S.current.ignore),
                    ),
                    const SizedBox(width: AppSize.a24),
                    Expanded(
                      child: HighLightButton(
                          onPress: () async {
                            _toggleShowProcess(true);
                            Navigator.of(context).pop(true);
                            if (await Common.isConnectToServer()) {
                              // BlocProvider.of<MqttBloc>(context)
                              //     .add(UnsubAllScribeEvent());
                              _accountBloc.add(LogoutAccountEvent());
                            } else {
                              _toggleShowProcess(false);
                              Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
                            }
                          },
                          title: S.current.accept),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18)
            ],
          ),
        ),
      ),
    );
    return showDialog(context: context, builder: (context) => alertDialog);
  }

  _toggleShowProcess(bool value) {
    setState(() {
      _isShowProcess = value;
    });
  }
}

class LanguageModel {
  final String name;
  final String code;
  final String countryCode;

  LanguageModel({required this.name, required this.code, required this.countryCode});
}
