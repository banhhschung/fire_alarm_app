import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_bloc.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_event.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_state.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/model/login_data_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailSettingPage extends StatefulWidget {
  final Account account;

  const UserDetailSettingPage({super.key, required this.account});

  @override
  State<StatefulWidget> createState() => _UserDetailSettingPageState();
}

class _UserDetailSettingPageState extends State<UserDetailSettingPage> {
  late AccountBloc _accountBloc;

  final TextEditingController _textFullNameEditingController = TextEditingController();
  final TextEditingController _textDateOfBirthEditingController = TextEditingController();
  final TextEditingController _textEmailEditingController = TextEditingController();
  final TextEditingController _textPhoneNumberEditingController = TextEditingController();

  late Account _currentAccountModel;

  final List<GenderOptionModel> _listGenderOptionModel = [
    GenderOptionModel(value: 0, gender: S.current.male),
    GenderOptionModel(value: 1, gender: S.current.female),
  ];
  late GenderOptionModel _currentGenderOptionModel;

  late bool _isShowProcess = false;

  @override
  void initState() {
    _accountBloc = AccountBloc();

    if (widget.account != null) {
      _currentAccountModel = widget.account;

      _textFullNameEditingController.text = _currentAccountModel.name ?? "";
      _textDateOfBirthEditingController.text = _currentAccountModel.birthDay ?? "";
      _currentGenderOptionModel =
          _listGenderOptionModel.firstWhere((element) => _currentAccountModel.gender == element.value, orElse: () => _listGenderOptionModel.first);
      _textEmailEditingController.text = _currentAccountModel.email ?? "";
      _textPhoneNumberEditingController.text = _currentAccountModel.phone ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.personal_information,
      ),
      body: _buildUserDetailSettingLayout()
    );
  }

  Widget _buildUserDetailSettingLayout(){
    return BlocListener<AccountBloc, AccountState>(
      bloc: _accountBloc,
      listener: (context, state){
        if(state is UpdateAccountSuccessState){
          _toggleShowProcess(false);
          Common.showSnackBarMessage(context, S.current.update_successful);
        } else if(state is UpdateAccountFailedState){
          Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
          _toggleShowProcess(false);
        }
      },
      child: CustomLoadingWidget(
        showLoading: _isShowProcess,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: Column(
            children: [
              Expanded(child: _buildUserSettingInformationLayout()),
              HighLightButton(onPress: () {
                _toggleShowProcess(true);
                _saveUserInformation();
              }, title: S.current.save_information),
              const SizedBox(
                height: AppSize.a24,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserSettingInformationLayout() {
    return Column(
      children: [
        _userInformationItemLayout(S.current.full_name, _textFullNameEditingController, S.current.enter_your_full_name),
        _userInformationItemLayout(S.current.date_of_birth, _textDateOfBirthEditingController, "${S.current.enter} ${S.current.date_of_birth.toLowerCase()}"),
        _buildGenderAccountItemLayout(),
        _userInformationItemLayout("Email", _textEmailEditingController, S.current.enter_email_address),
        _userInformationItemLayout(S.current.phone_number, _textPhoneNumberEditingController, ""),
      ],
    );
  }

  Widget _userInformationItemLayout(String title, TextEditingController textController, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(top: AppPadding.p16),
      child: CustomTextFieldWidget(
        titleInput: title,
        hintText: hintText,
        controller: textController,
        readOnly: textController == _textPhoneNumberEditingController ? true : false,
        // controller: _passwordController,
      ),
    );
  }

  Widget _buildGenderAccountItemLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: AppPadding.p16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.a10),
          border: Border.all(width: 1, color: Color(0xffB8B8D2))
        ),
        child: DropdownButton2<GenderOptionModel>(
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text(S.current.gender,),
          value: _currentGenderOptionModel,
          items: _listGenderOptionModel
              .map((e) => DropdownMenuItem(value: e, child: Text(e.gender)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _currentGenderOptionModel = value!;
            });
          },
          buttonStyleData: _dropdownStyle(),
          menuItemStyleData: _menuStyle(),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down, size: AppSize.a20, color: AppColors.secondaryText),
            openMenuIcon: Icon(Icons.keyboard_arrow_up, size: AppSize.a20, color: AppColors.secondaryText),
          ),

        ),
      ),
    );
  }

  ButtonStyleData _dropdownStyle() {
    return ButtonStyleData(
      height: AppSize.a50,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.a8),
      ),
    );
  }

  MenuItemStyleData _menuStyle() {
    return const MenuItemStyleData(
      height: AppSize.a48,
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
    );
  }

  void _saveUserInformation() async {
    _toggleShowProcess(true);
    if(await Common.isConnectToServer()){
      Account updateAccountModel = Account();
      updateAccountModel.providerMetadata = ProviderMetadata();
      updateAccountModel.name = _textFullNameEditingController.text;
      updateAccountModel.providerMetadata!.name = _textFullNameEditingController.text;
      updateAccountModel.providerMetadata!.email = _textEmailEditingController.text;
      updateAccountModel.birthDay = _textDateOfBirthEditingController.text;
      updateAccountModel.gender = _currentGenderOptionModel.value;
      updateAccountModel.email = _textDateOfBirthEditingController.text;
      if(updateAccountModel.providerId == ConfigApp.PROVIDER_LOGIN_PHONE_TYPE){
        updateAccountModel.phone = _textPhoneNumberEditingController.text;
      } else {
        updateAccountModel.providerMetadata!.phoneDetail = _textPhoneNumberEditingController.text;
      }
      if(updateAccountModel.iconPath != null && _currentAccountModel.iconPath != 'assets/images/default_avatar_ic.png'){
        updateAccountModel.providerMetadata!.iconPath = _currentAccountModel.iconPath;
      }

      if (_textFullNameEditingController.text.isEmpty){
        _toggleShowProcess(false);
        Common.showSnackBarMessage(context, S.current.name_empty, isError: true);
      } else {
        _accountBloc.add(UpdateAccountEvent(account: updateAccountModel));
      }
    } else {
      _toggleShowProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
    }
  }

  _toggleShowProcess(bool value) {
    setState(() {
      _isShowProcess = value;
    });
  }
}

class GenderOptionModel {
  final int value;
  final String gender;

  GenderOptionModel({required this.value, required this.gender});
}
