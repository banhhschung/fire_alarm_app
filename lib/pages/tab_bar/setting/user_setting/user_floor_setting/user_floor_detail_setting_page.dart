import 'package:fire_alarm_app/blocs/floor_bloc/floor_bloc.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_event.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_state.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/floor_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserFloorDetailSettingPage extends StatefulWidget {
  const UserFloorDetailSettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserFloorDetailSettingPageState();
}

class _UserFloorDetailSettingPageState extends State<UserFloorDetailSettingPage> {
  late FloorBloc _floorBloc;

  late TextEditingController _floorNameEditingController = TextEditingController();

  late List<FloorModel> _listFloors = [];

  late bool _isShowProcess = false;

  @override
  void initState() {
    _floorBloc = FloorBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(
          title: S.current.add_floor,
        ),
        body: BlocListener<FloorBloc, FloorState>(
            bloc: _floorBloc,
            listener: (context, state) {
              _toggleProcess(false);
              if (state is AddListFloorsSuccessState) {
                Common.showSnackBarMessage(context, S.current.update_successful);
                Future.delayed(const Duration(seconds: 3)).then((value) {
                  Navigator.of(context).pop(true);
                });
              } else if (state is AddListFloorsFailState) {
                Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
              }
            },
            child: _buildFloorSettingLayout()));
  }

  Widget _buildFloorSettingLayout() {
    return CustomLoadingWidget(
        showLoading: _isShowProcess, child: Padding(padding: const EdgeInsets.all(AppPadding.p16), child: _buildFloorSettingDetailLayout()));
  }

  Widget _buildFloorSettingDetailLayout() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              children: [
                _buildFloorNameSettingLayout(),
                const SizedBox(
                  height: AppSize.a28,
                ),
                _buildListRoomLayout()
              ],
            ),
          ),
        ),
        HighLightButton(
            onPress: () async {
              _toggleProcess(true);
              if (await Common.isConnectToServer()) {
                if (_listFloors.isNotEmpty) {
                  _floorBloc.add(AddListFloorsEvent(listFloor: _listFloors));
                } else {
                  _toggleProcess(false);
                  Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
                }
              } else {
                _toggleProcess(false);
                Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
              }
            },
            title: S.current.save_information)
      ],
    );
  }

  Widget _buildFloorNameSettingLayout() {
    double widthSize = MediaQuery.of(context).size.width;
    return SizedBox(
      width: widthSize,
      child: Row(
        children: [
          Expanded(
            child: CustomTextFieldWidget(
              titleInput: S.current.floor_name,
              controller: _floorNameEditingController,
            ),
          ),
          const SizedBox(
            width: AppSize.a20,
          ),
          Column(
            children: [
              const SizedBox(
                height: AppSize.a24,
              ),
              GestureDetector(
                  onTap: () {
                    _addFloorItemToList();
                  },
                  child: Assets.images.plusIcon.image(width: AppSize.a24)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildListRoomLayout() {
    return Expanded(
      child: _listFloors.isNotEmpty
          ? ListView.builder(itemCount: _listFloors.length, itemBuilder: (context, index) => _buildDetailRoomLayout(_listFloors[index]))
          : const SizedBox(),
    );
  }

  Widget _buildDetailRoomLayout(FloorModel floorModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.p16),
      child: Row(
        children: [
          Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p8),
                decoration: BoxDecoration(
                    border: Border.all(width: AppPadding.p1_5, color: AppColors.grey_4Background), borderRadius: BorderRadius.circular(AppSize.a8)),
                child: Text(
                  floorModel.name ?? "",
                  style: AppFonts.body2(),
                )),
          ),
          const SizedBox(
            width: AppSize.a20,
          ),
          GestureDetector(
              onTap: () {
                _removeFloorItemToList(floorModel);
              },
              child: Assets.images.minusIcon.image(width: AppSize.a24))
        ],
      ),
    );
  }

  void _addFloorItemToList() {
    if (_floorNameEditingController.text.trim().isNotEmpty) {
      _listFloors.insert(0, FloorModel(name: _floorNameEditingController.text.trim()));
      _floorNameEditingController.clear();
      setState(() {});
    } else {
      Common.showSnackBarMessage(context, S.current.you_need_to_enter_the_floor_name, isError: true);
    }
  }

  void _removeFloorItemToList(FloorModel floorModel) {
    _listFloors.remove(floorModel);
    setState(() {});
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
