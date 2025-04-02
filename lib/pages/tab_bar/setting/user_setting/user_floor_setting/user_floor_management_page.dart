import 'package:fire_alarm_app/blocs/floor_bloc/floor_bloc.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_event.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_state.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/floor_model.dart';
import 'package:fire_alarm_app/model/room_model.dart';
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

class UserFloorManagementPage extends StatefulWidget {
  const UserFloorManagementPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserFloorManagementPageState();
}

class _UserFloorManagementPageState extends State<UserFloorManagementPage> {
  late FloorBloc _floorBloc;

  late List<FloorModel> _floorModels = [
    FloorModel(id: 1, name: "Phòng 1", homeId: 12, rooms: [RoomModel(), RoomModel(), RoomModel(), RoomModel()])
  ];

  late bool _isShowProcess = false;

  @override
  void initState() {
    _floorBloc = FloorBloc()..add(GetListFloorEvent());
    _toggleProcess(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: S.current.floor_room,
      ),
      body: BlocListener<FloorBloc, FloorState>(
          bloc: _floorBloc,
          listener: (context, state) {
            _toggleProcess(false);
            if (state is GetListFloorSuccessState) {
              if (state.listFloorModels.isNotEmpty) {
                setState(() {
                  _floorModels = state.listFloorModels;
                });
              }
            } else if (state is GetListFloorFailState) {
            } else if (state is UpdateInformationFloorSuccessState) {
              _toggleProcess(true);
              _floorBloc.add(GetListFloorEvent());
              Common.showSnackBarMessage(context, S.current.update_successful);
            } else if (state is UpdateInformationFloorFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            } else if (state is RemoveFloorSuccessState){
              _toggleProcess(true);
              _floorBloc.add(GetListFloorEvent());
              Common.showSnackBarMessage(context, S.current.update_successful);
            } else if (state is RemoveFloorFailState){
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            }
          },
          child: _buildListFloorLayout()),
    );
  }

  Widget _buildListFloorLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.floor_list,
              style: AppFonts.title6(),
            ),
            const SizedBox(
              height: AppSize.a8,
            ),
            Expanded(child: ListView.builder(itemCount: _floorModels.length, itemBuilder: (context, index) => _buildFloorItemLayout(_floorModels[index]))),
            HighLightButton(
                onPress: () {
                  _addListFloorsFunction();
                },
                title: S.current.add_floor)
          ],
        ),
      ),
    );
  }

  Widget _buildFloorItemLayout(FloorModel floorModel) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.userRoomManagementPage, arguments: floorModel);
      },
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildFloorNameLayout(floorModel), _buildEditingFloorLayout(floorModel)],
        ),
      ),
    );
  }

  Widget _buildFloorNameLayout(FloorModel floorModel) {
    return Row(
      children: [
        Text(
          floorModel.name ?? "",
          style: AppFonts.title(),
        ),
      ],
    );
  }

  Widget _buildEditingFloorLayout(FloorModel floorModel) {
    return Row(
      children: [
        GestureDetector(
            onTap: () async {
              _editingFloorNameFunction(floorModel);
            },
            child: Assets.images.editPenIcon.image(width: AppSize.a20)),
        const SizedBox(
          width: AppSize.a30,
        ),
        GestureDetector(
            onTap: () async {
              _deleteFloorFunction(floorModel);
            },
            child: const Icon(
              Icons.delete,
              color: AppColors.errorPrimary,
              size: AppSize.a20,
            )),
      ],
    );
  }

  _toggleProcess(bool value) {
    setState(() {
      _isShowProcess = value;
    });
  }

  Future<void> _editingFloorNameFunction(FloorModel floorModel) async {
    await Common.showTextFieldPopup(context, title: S.current.rename_floor, titleInput: S.current.floor_name_title_input_text, value: floorModel.name ?? "")
        .then((value) async {
      _toggleProcess(true);
      if (await Common.isConnectToServer()) {
        if (value != null) {
          _floorBloc.add(UpdateInformationFloorEvent(floorId: floorModel.id!, floorName: value));
        }
      } else {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
      }
    });
  }

  Future<void> _deleteFloorFunction(FloorModel floorModel) async{
    _toggleProcess(true);
    if (await Common.isConnectToServer()){
      _floorBloc.add(RemoveFloorEvent(floorId: floorModel.id!));
    } else {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: false);
    }
  }

  Future<void> _addListFloorsFunction() async {
    bool? value = await Navigator.of(context).pushNamed(AppRoutes.userFloorDetailSettingPage) as bool?;
    if (value != null && value) {
      _toggleProcess(true);
      _floorBloc.add(GetListFloorEvent());
    }
  }
}
