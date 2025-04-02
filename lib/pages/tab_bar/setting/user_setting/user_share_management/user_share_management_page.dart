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
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserShareManagementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserShareManagementPageState();
}

class _UserShareManagementPageState extends State<UserShareManagementPage> {
  late ShareManagerBloc _shareManagerBloc;

  late List<ShareBuildingModel> _listShareBuildingModels = [];

  late bool _isShowProcess = false;

  @override
  void initState() {
    _toggleProcess(true);
    _shareManagerBloc = ShareManagerBloc()..add(GetListOfSharedAccountsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.add_members,
      ),
      body: BlocListener<ShareManagerBloc, ShareManagerState>(
          bloc: _shareManagerBloc,
          listener: (BuildContext context, ShareManagerState state) {
            _toggleProcess(false);
            if (state is GetListOfSharedAccountsSuccessState) {
              _listShareBuildingModels = state.listShareBuildingModel;
            } else if (state is GetListOfSharedAccountsFailState) {}
          },
          child: _buildUserShareManagementLayout()),
    );
  }

  Widget _buildUserShareManagementLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(child: _buildListSharedAccountLayout()),
            HighLightButton(
                onPress: () {
                  _addShareAccountFunction();
                },
                title: S.current.add_share)
          ],
        ),
      ),
    );
  }

  Widget _buildListSharedAccountLayout() {
    return ListView.builder(
        itemCount: _listShareBuildingModels.length, itemBuilder: (context, index) => _buildSharedAccountItemLayout(_listShareBuildingModels[index]));
  }

  Widget _buildSharedAccountItemLayout(ShareBuildingModel homeSharedModel) {
    return GestureDetector(
      onTap: (){
        _openDetailShareAccountFunction(homeSharedModel);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppPadding.p16),
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTypeOfSharedAccountLayout(homeSharedModel.type ?? 3),
                    const SizedBox(
                      height: AppSize.a8,
                    ),
                    Text(
                      homeSharedModel.userName ?? "??",
                      style: AppFonts.title3(),
                    ),
                    const SizedBox(
                      height: AppSize.a4,
                    ),
                    Text(
                      "ID: ${homeSharedModel.uuid ?? "??"}",
                      style: AppFonts.subTitle3(),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: AppSize.a20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeOfSharedAccountLayout(int type) {
    return Container(
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(AppSize.a24)), color: _buildMemberTypeBackgroundColor(type)),
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12, vertical: AppPadding.p4),
      child: Text(
        _buildMemberTypeTitle(type),
        style: AppFonts.buttonText3(color: _buildMemberTypeTextColor(type)),
      ),
    );
  }

  String _buildMemberTypeTitle(int type) {
    if (type == ConfigApp.MEMBER_TYPE_HOUSE_OWNER) {
      return S.current.house_owner;
    } else if (type == ConfigApp.MEMBER_TYPE_RELATIVE) {
      return S.current.relatives;
    } else {
      return S.current.guest;
    }
  }

  Color _buildMemberTypeBackgroundColor(int type) {
    if (type == ConfigApp.MEMBER_TYPE_HOUSE_OWNER) {
      return const Color(0xFFFFE6DF);
    } else {
      return AppColors.white;
    }
  }

  Color _buildMemberTypeTextColor(int type) {
    if (type == ConfigApp.MEMBER_TYPE_HOUSE_OWNER) {
      return AppColors.orangee;
    } else {
      return AppColors.primaryText;
    }
  }

  Future<void> _addShareAccountFunction() async {
    bool? value = await Navigator.of(context).pushNamed(AppRoutes.userAddShareMemberPage) as bool?;
    if (value != null && value) {
      _toggleProcess(true);
      if (await Common.isConnectToServer()) {
        _shareManagerBloc.add(GetListOfSharedAccountsEvent());
      } else {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
      }
    }
  }

  Future<void> _openDetailShareAccountFunction(ShareBuildingModel homeSharedModel) async {
    bool? value = await Navigator.of(context).pushNamed(AppRoutes.userBuildingShareDetailPage, arguments: homeSharedModel) as bool?;
    if (value != null && value) {
      _toggleProcess(true);
      if (await Common.isConnectToServer()) {
        _shareManagerBloc.add(GetListOfSharedAccountsEvent());
      } else {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
      }
    }
  }

  _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
