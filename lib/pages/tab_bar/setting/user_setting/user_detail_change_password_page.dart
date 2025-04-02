import 'package:fire_alarm_app/blocs/account_bloc/account_bloc.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_event.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_state.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailChangePasswordPage extends StatefulWidget {
  final Account account;

  const UserDetailChangePasswordPage({super.key, required this.account});

  @override
  State<StatefulWidget> createState() => _UserDetailChangePasswordPageState();
}

class _UserDetailChangePasswordPageState extends State<UserDetailChangePasswordPage> {
  late AccountBloc _accountBloc;

  final TextEditingController _oldPasswordTextEditingController = TextEditingController();
  final TextEditingController _newPasswordTextEditingController = TextEditingController();
  final TextEditingController _reEnterPasswordTextEditingController = TextEditingController();

  bool isPasswordLengthOk = false;
  bool isPasswordFormatOk = false;

  late Account _account;

  bool _isShowProcess = false;

  @override
  void initState() {
    _accountBloc = AccountBloc();
    _account = widget.account;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.change_password,
      ),
      body: BlocListener<AccountBloc, AccountState>(
        bloc: _accountBloc,
          listener: (context, state) async {
            if (state is AccountChangePasswordSuccessfulState) {
              _toggleProcess(false);
              await Common.showNormalPopup(
                  context,
                  title: S.current.notification,
                  content: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(AppPadding.p24),
                        child: Text(
                          S.current.password_changed_successfully_please_log_in_again_with_the_new_password,
                          textAlign: TextAlign.center,
                        )),
                  ),);
              _accountBloc.add(LogoutAccountEvent());
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginPage, (_) => false);
            } else if (state is AccountChangePasswordFailState) {
              _toggleProcess(false);
            }
          },
          child: _buildUserChangePasswordLayout()),
    );
  }

  Widget _buildUserChangePasswordLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildUserChangePasswordItemLayout(S.current.old_password, _oldPasswordTextEditingController),
                  const SizedBox(
                    height: AppSize.a16,
                  ),
                  _buildUserChangePasswordItemLayout(S.current.new_password, _newPasswordTextEditingController),
                  const SizedBox(
                    height: AppSize.a4,
                  ),
                  _checkPasswordFormatLayout(),
                  const SizedBox(
                    height: AppSize.a16,
                  ),
                  _buildUserChangePasswordItemLayout(S.current.re_enter_password, _reEnterPasswordTextEditingController),
                ],
              ),
            ),
            HighLightButton(
                onPress: () {
                  _changePasswordFunction();
                },
                title: S.current.save_information)
          ],
        ),
      ),
    );
  }

  Widget _buildUserChangePasswordItemLayout(String title, TextEditingController textController) {
    return CustomTextFieldWidget(
      titleInput: title,
      isPassword: true,
      controller: textController,
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

  void _changePasswordFunction() async {
    _toggleProcess(true);
    if (await Common.isConnectToServer()) {
      var oldPassword = _oldPasswordTextEditingController.text;
      var newPassword = _newPasswordTextEditingController.text;
      var newPassRetype = _reEnterPasswordTextEditingController.text;
      if (oldPassword.isEmpty) {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.please_enter_current_password, isError: true);
      } else if (oldPassword != _account.password) {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.old_password_is_incorrect, isError: true);
      } else if (newPassword.isEmpty) {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.password_empty, isError: true);
      } else if (newPassword.isNotEmpty && newPassword.length < 6) {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.wrong_password_format, isError: true);
      } else if (newPassword.contains(' ')) {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.wrong_password_format, isError: true);
      } else if (newPassRetype.isEmpty) {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.please_re_enter_password, isError: true);
      } else if (newPassRetype != newPassword) {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.re_enter_incorrect_password, isError: true);
      } else {
        _accountBloc.add(AccountChangePasswordEvent(oldPassword: oldPassword, newPassword: newPassword));
      }
    } else {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
    }
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
