import 'package:fire_alarm_app/blocs/building_bloc/building_bloc.dart';
import 'package:fire_alarm_app/blocs/building_bloc/building_event.dart';
import 'package:fire_alarm_app/blocs/building_bloc/building_state.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/building_location_model.dart';
import 'package:fire_alarm_app/model/building_model.dart';
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

class UserBuildingSettingPage extends StatefulWidget {
  final BuildingModel buildingModel;

  const UserBuildingSettingPage({super.key, required this.buildingModel});

  @override
  State<StatefulWidget> createState() => _UserBuildingSettingPageState();
}

class _UserBuildingSettingPageState extends State<UserBuildingSettingPage> {
  late BuildingBloc _buildingBloc;

  late BuildingModel _buildingModel;
  late BuildingLocationModel _buildingLocationModel;
  final TextEditingController _buildingNameTextEditingController = TextEditingController();

  bool _isShowProcess = false;

  @override
  void initState() {
    _buildingBloc = BuildingBloc();
    if (widget.buildingModel.id != null) {
      _buildingModel = widget.buildingModel;
      _buildingNameTextEditingController.text = _buildingModel.name ?? "";
      _buildingLocationModel = BuildingLocationModel(
          districtId: _buildingModel.districtId,
          provinceId: _buildingModel.provinceId,
          provinceCode: _buildingModel.provinceCode,
          address: _buildingModel.address);
    } else {
      _buildingModel = BuildingModel(type: ConfigApp.MEMBER_TYPE_HOUSE_OWNER);
      _buildingLocationModel = BuildingLocationModel();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: S.current.house,
      ),
      body: BlocListener<BuildingBloc, BuildingState>(
          bloc: _buildingBloc,
          listener: (context, state) async {
            _toggleProcess(false);
            if (state is AddBuildingSuccessState) {
              Common.showSnackBarMessage(context, S.current.successfully_created_new_building);
              // await Future.delayed(const Duration(seconds: 4));
              Navigator.of(context).pop(true);
            } else if (state is AddBuildingFailState) {
              Common.showSnackBarMessage(context, S.current.creating_new_building_failed_please_try_again, isError: true);
            } else if (state is UpdateBuildingSuccessState) {
              Common.showSnackBarMessage(context, S.current.update_successful);
              Future.delayed(Duration(seconds: 3)).then((value) {
                Navigator.of(context).pop(true);
              });
            } else if (state is UpdateBuildingFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            }
          },
          child: _buildBuildingMainLayout()),
    );
  }

  Widget _buildBuildingMainLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [Expanded(child: _buildBuildingSettingLayout()), _buildSaveInformationBuildingLayout()],
        ),
      ),
    );
  }

  Widget _buildBuildingSettingLayout() {
    return Column(children: [
      _buildNameAndImageBuildingLayout(),
      const SizedBox(
        height: AppSize.a24,
      ),
      _buildLocationBuildingSettingLayout()
    ]);
  }

  Widget _buildNameAndImageBuildingLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
      child: Column(
        children: [
          _buildImageHouseItemLayout(),
          const SizedBox(
            height: AppSize.a16,
          ),
          CustomTextFieldWidget(
            controller: _buildingNameTextEditingController,
            titleInput: S.current.building_name,
          ),
        ],
      ),
    );
  }

  Widget _buildImageHouseItemLayout() {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = widthSize * 9 / 16;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSize.a8)),
      width: widthSize,
      height: heightSize,
      child: Image.network(
        'https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-cute-54.png',
      ),
    );
  }

  Widget _buildLocationBuildingSettingLayout() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _openUserBuildingAddressSettingPage();
      },
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _buildTitleForLocationBuildingLayout(),
              style: AppFonts.title(),
            ),
            const Icon(
              Icons.chevron_right_outlined,
              size: AppSize.a16,
            )
          ],
        ),
      ),
    );
  }

  String _buildTitleForLocationBuildingLayout() {
    if (_buildingLocationModel.address != null) {
      return "${_buildingLocationModel.address ?? ""} ${_buildingLocationModel.provinceCode ?? ""}";
    } else {
      return S.current.address;
    }
  }

  Widget _buildSaveInformationBuildingLayout() {
    return Visibility(
        visible: _buildingModel.type == ConfigApp.MEMBER_TYPE_HOUSE_OWNER,
        child: HighLightButton(
            onPress: () {
              _saveInformationBuildingFunction();
            },
            title: S.current.save_information));
  }

  void _saveInformationBuildingFunction() async {
    if (!await Common.isConnectToServer()) {
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
      return;
    }
    if (_buildingNameTextEditingController.text.trim().isEmpty) {
      Common.showSnackBarMessage(context, S.current.you_need_to_enter_the_building_name, isError: true);
    } else if (_buildingNameTextEditingController.text.length > 25) {
      Common.showSnackBarMessage(context, S.current.you_need_to_enter_a_building_name_of_less_than_25_characters, isError: true);
    } else if (_buildingLocationModel == null || _buildingLocationModel.address == null || _buildingLocationModel.address!.trim().isEmpty) {
      Common.showSnackBarMessage(context, S.current.you_need_to_enter_the_building_address, isError: true);
    } else {
      _toggleProcess(true);
      if (_buildingModel.id == null) {
        _buildingBloc
            .add(AddBuildingEvent(buildingName: _buildingNameTextEditingController.text, buildingImage: "", buildingLocationModel: _buildingLocationModel));
      } else {
        _buildingBloc.add(UpdateBuildingEvent(
            buildingId: _buildingModel.id!,
            buildingName: _buildingNameTextEditingController.text,
            buildingImage: "",
            buildingLocationModel: _buildingLocationModel));
      }
    }
  }

  void _openUserBuildingAddressSettingPage() async {
    if (await Common.isConnectToServer()) {
      BuildingLocationModel? result = await Navigator.of(context).pushNamed(AppRoutes.userBuildingAddressSettingPage, arguments: _buildingModel) as BuildingLocationModel?;
      if (result != null) {
        setState(() {
          _buildingLocationModel = result;
        });
      }
    } else {
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
    }
  }

  _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
