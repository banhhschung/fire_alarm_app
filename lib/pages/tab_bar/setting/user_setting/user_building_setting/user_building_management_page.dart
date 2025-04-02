import 'package:fire_alarm_app/blocs/building_bloc/building_bloc.dart';
import 'package:fire_alarm_app/blocs/building_bloc/building_event.dart';
import 'package:fire_alarm_app/blocs/building_bloc/building_state.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/building_location_model.dart';
import 'package:fire_alarm_app/model/building_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBuildingManagementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserBuildingManagementPageState();
}

class _UserBuildingManagementPageState extends State<UserBuildingManagementPage> {
  late List<BuildingModel> _listBuildings = [];
  late BuildingBloc _buildingBloc;

  late bool _isShowProcess = false;

  @override
  void initState() {
    _buildingBloc = BuildingBloc()..add(GetListBuildingEvent());
    _toggleProcess(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.building_management,
      ),
      body: BlocListener<BuildingBloc, BuildingState>(
        bloc: _buildingBloc,
        listener: (BuildContext context, state) {
          if (state is GetListBuildingState) {
            setState(() {
              _listBuildings = state.listBuildingModel;
            });
          }
          _toggleProcess(false);
        },
        child: CustomLoadingWidget(
          showLoading: _isShowProcess,
          child: _buildListBuildingLayout(),
        ),
      ),
    );
  }

  Widget _buildListBuildingLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        children: [
          Expanded(child: ListView.builder(itemCount: _listBuildings.length, itemBuilder: (context, index) => _buildBuildingItemLayout(_listBuildings[index]))),
          HighLightButton(
              onPress: () {
                _openUserBuildingSettingPage();
              },
              title: S.current.add_house)
        ],
      ),
    );
  }

  Widget _buildBuildingItemLayout(BuildingModel buildingModel) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _openUserBuildingSettingPage(buildingModel: buildingModel);
      },
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.network(
              'https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-cute-54.png',
              width: AppSize.a80,
              height: AppSize.a70,
            ),
            Expanded(
              child: Column(
                children: [
                  _buildNameAndStatusBuildingLayout(buildingModel),
                  const SizedBox(
                    height: AppSize.a18,
                  ),
                  _buildLocationBuildingDetailLayout(buildingModel)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndStatusBuildingLayout(BuildingModel buildingModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          buildingModel.name ?? "???",
          style: AppFonts.title5(),
        ),
        _buildBuildingStatusItem()
      ],
    );
  }

  Widget _buildBuildingStatusItem() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p2, horizontal: AppPadding.p8),
      decoration: BoxDecoration(
        color: AppColors.primaryPressedActive,
        borderRadius: BorderRadius.circular(AppSize.a6),
      ),
      child: Text(
        "Bình thường",
        style: AppFonts.title(color: AppColors.onColorBackground, fontSize: AppSize.a10),
      ),
    );
  }

  Widget _buildLocationBuildingDetailLayout(BuildingModel buildingModel) {
    String locationBuilding = "${buildingModel.address ?? ""} - ${buildingModel.provinceCode ?? ""}";
    return Row(
      children: [
        Assets.images.locationIcon.image(width: AppSize.a16),
        const SizedBox(
          width: AppSize.a4,
        ),
        Text(
          locationBuilding,
          style: AppFonts.subTitle3(),
        )
      ],
    );
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }

  Future<void> _openUserBuildingSettingPage({BuildingModel? buildingModel}) async {
    bool? result;
    if (buildingModel != null) {
      result = await Navigator.of(context).pushNamed(AppRoutes.userBuildingSettingPage, arguments: buildingModel) as bool?;
    } else {
      result = await Navigator.of(context).pushNamed(AppRoutes.userBuildingSettingPage, arguments: BuildingModel()) as bool?;
    }
    if (result != null && result) {
      _buildingBloc.add(GetListBuildingEvent());
      _toggleProcess(true);
    }
  }
}
