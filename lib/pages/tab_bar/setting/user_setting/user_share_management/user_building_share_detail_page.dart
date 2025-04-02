import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_event.dart';
import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_state.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/share_building_model.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBuildingShareDetailPage extends StatefulWidget {
  final ShareBuildingModel shareBuildingModel;

  const UserBuildingShareDetailPage({super.key, required this.shareBuildingModel});

  @override
  State<StatefulWidget> createState() => _UserBuildingShareDetailPageState();
}

class _UserBuildingShareDetailPageState extends State<UserBuildingShareDetailPage> {
  late ShareManagerBloc _shareManagerBloc;

  late ShareBuildingModel _shareBuildingModel;

  late bool _isShowProcess = false;

  @override
  void initState() {
    _shareBuildingModel = widget.shareBuildingModel;
    _shareManagerBloc = ShareManagerBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: S.current.share_management,
      ),
      body: BlocListener<ShareManagerBloc, ShareManagerState>(
          bloc: _shareManagerBloc,
          listener: (BuildContext context, ShareManagerState state) {
            _toggleProcess(false);
            if (state is RemoveBuildingShareAccountSuccessState) {
              Common.showSnackBarMessage(context, S.current.update_successful);
              Future.delayed(const Duration(seconds: 3)).then((value) {
                Navigator.of(context).pop(true);
              });
            } else if (state is RemoveBuildingShareAccountFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            }
          },
          child: _buildUserBuildingShareDetailPageLayout()),
    );
  }

  Widget _buildUserBuildingShareDetailPageLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildBuildingShareItemInformationLayout(S.current.full_name, _shareBuildingModel.userName),
                  const SizedBox(
                    height: AppSize.a8,
                  ),
                  _buildBuildingShareItemInformationLayout("ID", _shareBuildingModel.uuid),
                  const SizedBox(
                    height: AppSize.a8,
                  ),
                  _buildBuildingShareItemInformationLayout("Email", _shareBuildingModel.email),
                  const SizedBox(
                    height: AppSize.a8,
                  ),
                  _buildBuildingShareItemInformationLayout(S.current.phone_number, _shareBuildingModel.phoneNumber),
                  const SizedBox(
                    height: AppSize.a8,
                  ),
                  _buildBuildingShareItemInformationLayout(
                      S.current.account_type, _shareBuildingModel.type == ConfigApp.MEMBER_TYPE_RELATIVE ? S.current.relatives : S.current.guest,
                      moreSetting: true),
                  const SizedBox(
                    height: AppSize.a8,
                  ),
                  _buildBuildingShareItemInformationLayout(S.current.share_settings, _shareBuildingModel.userName, moreSetting: true),
                ],
              ),
            ),
            HighLightButton(
                title: S.current.delete,
                onPress: () {
                  _removeShareBuildingAccountFunction();
                })
          ],
        ),
      ),
    );
  }

  Widget _buildBuildingShareItemInformationLayout(String title, String? value, {bool moreSetting = false}) {
    return GestureDetector(
      onTap: () {
        if (moreSetting) {
          _openDetailBuildingShareAccountFunction();
        }
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSize.a8)),
        margin: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppFonts.buttonText2(),
            ),
            Row(
              children: [
                Text(
                  value ?? "",
                  style: AppFonts.title(),
                ),
                if (moreSetting)
                  const Row(
                    children: [
                      SizedBox(
                        width: AppSize.a4,
                      ),
                      Icon(Icons.chevron_right_outlined)
                    ],
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeShareBuildingAccountFunction() async {
    var result = await Common.showNormalPopup(context,
        title: S.current.notification,
        content: Center(
          child: Padding(
              padding: const EdgeInsets.all(AppPadding.p24),
              child: Text(
                S.current.do_you_want_to_delete_the_share,
                textAlign: TextAlign.center,
              )),
        ),
        isCloseWhenDone: false, onPressedDone: () {
      Navigator.of(context).pop(true);
    });
    if (result != null && result) {
      _toggleProcess(true);
      if (await Common.isConnectToServer()) {
        if (_shareBuildingModel.id != null) {
          _shareManagerBloc.add(RemoveBuildingShareAccountEvent(userId: _shareBuildingModel.id!));
        }
      } else {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: false);
      }
    }
  }

  void _openDetailBuildingShareAccountFunction() async {
    _toggleProcess(true);
    if(await Common.isConnectToServer()){
      _toggleProcess(false);
      bool? value = await Navigator.of(context).pushNamed(AppRoutes.userSettingShareTypePage, arguments: _shareBuildingModel) as bool?;
      if(value != null && value){
        Navigator.of(context).pop(true);
      }
    } else {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
    }
  }

  _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
