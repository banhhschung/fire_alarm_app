import 'package:cached_network_image/cached_network_image.dart';
import 'package:fire_alarm_app/blocs/room_bloc/room_bloc.dart';
import 'package:fire_alarm_app/blocs/room_bloc/room_event.dart';
import 'package:fire_alarm_app/blocs/room_bloc/room_state.dart';
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

class UserRoomManagementPage extends StatefulWidget {
  final FloorModel floorModel;

  const UserRoomManagementPage({super.key, required this.floorModel});

  @override
  State<StatefulWidget> createState() => _UserRoomManagementPageState();
}

class _UserRoomManagementPageState extends State<UserRoomManagementPage> {
  late RoomBloc _roomBloc;

  late FloorModel _currentFloorModel;
  late List<RoomModel> _roomModels = [];
  late bool _isShowProcess = false;
  String tempImage = "https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-cute-54.png";

  @override
  void initState() {
    _toggleProcess(true);
    _currentFloorModel = widget.floorModel;
    _roomBloc = RoomBloc()..add(GetListRoomsByFloorIdEvent(_currentFloorModel.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: S.current.room_list,
      ),
      body: BlocListener<RoomBloc, RoomState>(
          bloc: _roomBloc,
          listener: (context, state) {
            _toggleProcess(false);
            if (state is GetListRoomByFloorIdState) {
              if (state.listRoomModels.isNotEmpty) {
                _roomModels = state.listRoomModels;
              }
            } else if (state is UpdateRoomInformationSuccessState) {
              _roomBloc.add(GetListRoomsByFloorIdEvent(_currentFloorModel.id));
              Common.showSnackBarMessage(context, S.current.update_successful);
              _toggleProcess(true);
            } else if (state is UpdateRoomInformationFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            } else if (state is RemoveRoomByIdSuccessState){
              _roomBloc.add(GetListRoomsByFloorIdEvent(_currentFloorModel.id));
              Common.showSnackBarMessage(context, S.current.update_successful);
              _toggleProcess(true);
            } else if (state is RemoveRoomByIdFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            }
          },
          child: _buildUserRoomManagementLayout()),
    );
  }

  Widget _buildUserRoomManagementLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.room_list,
              style: AppFonts.title6(),
            ),
            const SizedBox(
              height: AppSize.a8,
            ),
            Expanded(child: ListView.builder(itemCount: _roomModels.length, itemBuilder: (context, index) => _buildRoomItemLayout(_roomModels[index]))),
            HighLightButton(onPress: () {}, title: S.current.add_floor)
          ],
        ),
      ),
    );
  }

  Widget _buildRoomItemLayout(RoomModel roomModel) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.userRoomDetailSettingPage, arguments: roomModel);
      },
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(AppSize.a8))),
        child: Row(
          children: [
            CachedNetworkImage(
              placeholder: (context, url) => const Center(
                child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
              ),
              width: AppSize.a40,
              height: AppSize.a40,
              imageUrl: roomModel.imageUrl ?? "",
              errorWidget: (a, b, c) => Image.network(
                tempImage,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: AppSize.a16,
            ),
            Expanded(
                child: Text(
              roomModel.name ?? "",
              style: AppFonts.title(),
            )),
            _buildEditingRoomLayout(roomModel)
          ],
        ),
      ),
    );
  }

  Widget _buildEditingRoomLayout(RoomModel roomModel) {
    return Row(
      children: [
        GestureDetector(
            onTap: () async {
              _editingRoomNameFunction(roomModel);
            },
            child: Assets.images.editPenIcon.image(width: AppSize.a20)),
        const SizedBox(
          width: AppSize.a30,
        ),
        GestureDetector(
          onTap: () async {
            _deleteRoomFunction(roomModel);
          },
          child: const Icon(
            Icons.delete,
            color: AppColors.errorPrimary,
            size: AppSize.a20,
          ),
        ),
      ],
    );
  }

  Future<void> _editingRoomNameFunction(RoomModel roomModel) async {
    await Common.showTextFieldPopup(context, title: S.current.rename_room, titleInput: S.current.room_name, value: roomModel.name ?? "").then((value) async {
      if (value != null) {
        if (await Common.isConnectToServer()) {
          _toggleProcess(true);
          var tempRoomModel = roomModel;
          tempRoomModel.name = value;
          _roomBloc.add(UpdateRoomInformationEvent(roomModel: tempRoomModel));
        } else {
          _toggleProcess(false);
          Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
        }
      }
    });
  }

  Future<void> _deleteRoomFunction(RoomModel roomModel) async {
    Common.showRequiteAgreePopup(context, title: S.current.notification, content: S.current.do_you_want_to_delete_this_room, onPressedDone: () async {
      _toggleProcess(true);
      if (await Common.isConnectToServer()) {
        _roomBloc.add(RemoveRoomByIdEvent(roomId: roomModel.id!));
      } else {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: false);
      }
    });
  }

  _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
