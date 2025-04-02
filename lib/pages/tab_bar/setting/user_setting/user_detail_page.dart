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
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class UserDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late AccountBloc _accountBloc;

  Account? _currentAccountModel;

  @override
  void initState() {
    _accountBloc = AccountBloc()..add(GetAccountLoginEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBarWidget(title: S.current.personal_information), body: _buildUserInformationLayout());
  }

  Widget _buildUserInformationLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        children: [
          Expanded(child: _buildUserDetailInformationLayout()),
          _buildSettingUserInformation()
        ],
      ),
    );
  }

  Widget _buildUserDetailInformationLayout() {
    return BlocBuilder(
      bloc: _accountBloc,
      builder: (context, state){
        if(state is GetAccountLoginState){
          _currentAccountModel = state.account;
        }
        return _currentAccountModel != null ? Column(
          children: [
            _buildShareInformationByUserLayout(),
            _buildUserInformationItemLayout(S.current.full_name, _currentAccountModel!.name ?? ""),
            _buildUserInformationItemLayout(S.current.date_of_birth, _currentAccountModel!.birthDay ?? ""),
            _buildUserInformationItemLayout(S.current.gender, _buildGenderAccountString()),
            _buildUserInformationItemLayout("Email", _currentAccountModel!.email ?? ""),
            _buildUserInformationItemLayout(S.current.phone_number, _currentAccountModel!.phone ?? ""),
          ],
        ) : SizedBox();
      },
    );
  }

  Widget _buildShareInformationByUserLayout() {
    return Column(
      children: [
        _buildQrByUserLayout(),
        const SizedBox(
          height: AppSize.a16,
        ),
        Text(
          "123123123123123123",
          style: AppFonts.title(),
        ),
        const SizedBox(
          height: AppSize.a16,
        ),
      ],
    );
  }

  Widget _buildQrByUserLayout() {
    return SizedBox(
      height: AppSize.a150,
      width: AppSize.a150,
      child: PrettyQrView.data(
        data: "https://www.youtube.com",
        decoration: PrettyQrDecoration(
          image: PrettyQrDecorationImage(
            image: NetworkImage('https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-cute-54.png'),
          ),
          shape: PrettyQrSmoothSymbol(),
        ),
      ),
    );
  }

  Widget _buildUserInformationItemLayout(String title, String stringValue) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSize.a8)),
      margin: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppFonts.buttonText2(),
          ),
          Text(
            stringValue,
            style: AppFonts.title(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingUserInformation() {
    return Column(
      children: [
        HighLightButton(
          onPress: () {
            Navigator.of(context).pushNamed(AppRoutes.userDetailChangePasswordPage, arguments: _currentAccountModel);
          },
          title: S.current.change_password,
          textStyle: AppFonts.buttonText2(color: AppColors.orangee),
          buttonColor: AppColors.white,
        ),
        const SizedBox(
          height: AppSize.a16,
        ),
        HighLightButton(onPress: () {
          Navigator.of(context).pushNamed(AppRoutes.userDetailSettingPage, arguments: _currentAccountModel);
        }, title: S.current.edit_information)
      ],
    );
  }

  String _buildGenderAccountString(){
    String gender = "";
    if(_currentAccountModel != null){
      if(_currentAccountModel!.gender != null){
        gender = _currentAccountModel!.gender == 1 ? S.current.female : S.current.male;
        return gender;
      } else{
        return gender;
      }
    }else{
      return gender;
    }
  }
}
