import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_event.dart';
import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_state.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/share_building_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSettingShareTypePage extends StatefulWidget {
  final ShareBuildingModel shareBuildingModel;

  const UserSettingShareTypePage({super.key, required this.shareBuildingModel});

  @override
  State<StatefulWidget> createState() => _UserSettingShareTypePageState();
}

class _UserSettingShareTypePageState extends State<UserSettingShareTypePage> {
  late ShareManagerBloc _shareManagerBloc;

  late int _buildingShareType;
  late DateTime _expireDate = DateTime.now();

  late bool _isShowProcess = false;

  @override
  void initState() {
    if (widget.shareBuildingModel.type != null) {
      _buildingShareType = widget.shareBuildingModel.type!;
    }
    if (widget.shareBuildingModel.expiredTime != null) {
      _expireDate = DateTime.fromMillisecondsSinceEpoch(widget.shareBuildingModel.expiredTime!);
    }
    _shareManagerBloc = ShareManagerBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.account_type,
      ),
      body: BlocListener<ShareManagerBloc, ShareManagerState>(
          bloc: _shareManagerBloc,
          listener: (BuildContext context, state) {
            _toggleProcess(false);
            if (state is UpdateBuildingShareAccountSuccessState) {
              Common.showSnackBarMessage(context, S.current.update_successful);
              Future.delayed(const Duration(seconds: 3)).then((value) {
                Navigator.of(context).pop(true);
              });
            } else if (state is UpdateBuildingShareAccountFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            }
          },
          child: _buildUserSettingShareTypePageLayout()),
    );
  }

  Widget _buildUserSettingShareTypePageLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildOptionTypeShareBuildingTypeLayout(ConfigApp.MEMBER_TYPE_RELATIVE),
                  _buildOptionTypeShareBuildingTypeLayout(ConfigApp.MEMBER_TYPE_GUEST),
                ],
              ),
            ),
            HighLightButton(
                title: S.current.save,
                onPress: () {
                  _saveBuildingShareTypeFunction();
                })
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTypeShareBuildingTypeLayout(int type) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        setState(() {
          _buildingShareType = type;
        });
        if(type == ConfigApp.MEMBER_TYPE_GUEST){
          _selectDate(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type == ConfigApp.MEMBER_TYPE_RELATIVE ? S.current.relatives : S.current.guest,
              style: AppFonts.title(),
            ),
            Row(
              children: [
                if(type == ConfigApp.MEMBER_TYPE_GUEST) Row(
                  children: [
                    Text(convertTimestampToDDMMYYYY(_expireDate.millisecondsSinceEpoch), style: AppFonts.title(),),
                    const SizedBox(width: AppSize.a16,)
                  ],
                ),
                _buildChooseOptionBoxLayout(_buildingShareType == type),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChooseOptionBoxLayout(bool value) {
    return value
        ? const Icon(Icons.radio_button_checked, color: AppColors.errorPrimary)
        : const Icon(
            Icons.radio_button_off,
            color: AppColors.primaryText,
          );
  }

  Future<void> _saveBuildingShareTypeFunction() async {
    _toggleProcess(true);
    if (await Common.isConnectToServer()) {
      if (widget.shareBuildingModel.id != null) {
        if(_buildingShareType == ConfigApp.MEMBER_TYPE_GUEST && (DateTime.now().millisecondsSinceEpoch > _expireDate.millisecondsSinceEpoch)){
          _toggleProcess(false);
          Common.showSnackBarMessage(context, S.current.the_selected_time_must_be_greater_than_the_current_time, isError: true);
        } else {
          _shareManagerBloc.add(UpdateBuildingShareAccountEvent(
              id: widget.shareBuildingModel.id!,
              type: _buildingShareType,
              expiredTime: _buildingShareType == ConfigApp.MEMBER_TYPE_GUEST ? _expireDate.millisecondsSinceEpoch : null));
        }
      }
    } else {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _expireDate) {
      setState(() {
        _expireDate = picked;
      });
    }
  }

  _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }

  String convertTimestampToDDMMYYYY(int timestamp) {
    if (timestamp == null || timestamp < 0) {
      return '__';
    }
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${getTime(date.day)}/${getTime(date.month)}/${getTime(date.year)}';
  }

  String getTime(int value){
    return value < 10? '0${value.toString()}' : value.toString();
  }
}
