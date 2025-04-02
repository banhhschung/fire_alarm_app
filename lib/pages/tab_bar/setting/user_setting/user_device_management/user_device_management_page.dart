import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_event.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_state.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_bloc.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_event.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_state.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/floor_model.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_device_management/sub_device_management_page.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDeviceManagementPage extends StatefulWidget {
  const UserDeviceManagementPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserDeviceManagementPageState();
}

class _UserDeviceManagementPageState extends State<UserDeviceManagementPage> with TickerProviderStateMixin {
  late TabBarView _tabBarView;
  late TabController _tabBarController;
  late DeviceManagerBloc _deviceManagerBloc;
  late FloorBloc _floorBloc;

  late List<Device> _listDevice = [];
  late List<FloorModel> _listFloor = [FloorModel(name: "All")];

  late bool _isShowProcess = false;

  @override
  void initState() {
    _tabBarController = TabController(vsync: this, length: _listFloor.length);
    _tabBarView = TabBarView(controller: _tabBarController, children: [SubDeviceManagementPage()]);
    _floorBloc = FloorBloc()..add(GetListFloorEvent());
    _deviceManagerBloc = DeviceManagerBloc(BlocProvider.of<MqttBloc>(context));
    _toggleProcess(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.device_management,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<FloorBloc, FloorState>(
            bloc: _floorBloc,
            listener: (context, state) {
              _toggleProcess(false);
              if (state is GetListFloorSuccessState) {
                _toggleProcess(true);
                _listFloor.clear();
                _listFloor.addAll(state.listFloorModels);
                _listFloor.insert(0, FloorModel(id: null, name: "Tất cả thiết bị"));
                _tabBarController.dispose();
                _tabBarController = TabController(length: _listFloor.length, vsync: this);
                _deviceManagerBloc.add(GetListDeviceInAccountDeviceEvent());
              } else if (state is GetListFloorFailState) {
                Common.showSnackBarMessage(context, "Không lấy được dữ liệu tầng phòng", isError: true);
              }
            },
          ),
          BlocListener<DeviceManagerBloc, DeviceManagerState>(
            bloc: _deviceManagerBloc,
            listener: (context, state) {
              _toggleProcess(false);
              if (state is GetListDeviceInAccountDeviceSuccessState) {
                _listDevice = state.listDevice;
                for (Widget widget in _tabBarView.children) {
                  if (widget is SubDeviceManagementPage) {
                    widget.changeListDevice(_listDevice);
                  }
                }
                setState(() {});
              } else if (state is GetListDeviceInAccountDeviceFailState) {}
            },
          )
        ],
        child: CustomLoadingWidget(showLoading: _isShowProcess, child: _buildUserDeviceManagementLayout()),
      ),
    );
  }

  Widget _buildUserDeviceManagementLayout() {
    return Column(
      children: [
        TabBar(
          controller: _tabBarController,
          dividerColor: Colors.transparent,
          tabs: _listFloor
              .map((element) => Tab(
                    text: element.name,
                  ))
              .toList(),
        ),
        Expanded(child: _tabBarView)
      ],
    );
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
