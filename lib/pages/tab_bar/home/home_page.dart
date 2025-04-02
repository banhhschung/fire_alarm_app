import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fire_alarm_app/blocs/building_bloc/building_bloc.dart';
import 'package:fire_alarm_app/blocs/building_bloc/building_event.dart';
import 'package:fire_alarm_app/blocs/building_bloc/building_state.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_event.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_state.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_bloc.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_event.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_state.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/blocs/room_bloc/room_bloc.dart';
import 'package:fire_alarm_app/blocs/room_bloc/room_event.dart';
import 'package:fire_alarm_app/blocs/room_bloc/room_state.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/floor_model.dart';
import 'package:fire_alarm_app/model/building_model.dart';
import 'package:fire_alarm_app/model/room_model.dart';
import 'package:fire_alarm_app/pages/tab_bar/home/sub_home_list_param_group_by_room.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late BuildingBloc _buildingBloc;
  late FloorBloc _floorBloc;
  late RoomBloc _roomBloc;
  late DeviceManagerBloc _deviceManagerBloc;
  late MqttBloc _mqttBloc;

  late List<BuildingModel> _listBuildingModels = [];
  late List<FloorModel> _listFloorModels = [];
  late List<RoomModel> _listRoomModels = [RoomModel()];
  late List<Device> _listDevice = [];

  late FloorModel _currentFloorModel = FloorModel();

  late TabBarView _tabBarView;
  late TabController _tabBarController;
  final ScrollController _scrollController = ScrollController();

  int _currentIndex = 0;

  @override
  void initState() {
    _buildingBloc = BuildingBloc()..add(GetListBuildingEvent());
    _floorBloc = FloorBloc();
    _roomBloc = RoomBloc();
    _deviceManagerBloc = DeviceManagerBloc(BlocProvider.of<MqttBloc>(context));
    _mqttBloc = BlocProvider.of<MqttBloc>(context);
    _tabBarController = TabController(vsync: this, length: _listRoomModels.length);
    _tabBarView = TabBarView(
      controller: _tabBarController,
      children: [
        SubHomeListParamGroupByRoom(),
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.parallax, background: _headerHomeLayout()),
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 180),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: AppColors.orangee, borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0))),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [_subHeaderTabLayout()]
                        // children: [
                        //   _listBuildingItemLayout()
                        // ],
                        ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: MultiBlocListener(
          listeners: [
            BlocListener<BuildingBloc, BuildingState>(
              bloc: _buildingBloc,
              listener: (context, state) {
                if (state is GetListBuildingState) {
                  _listBuildingModels = state.listBuildingModel;
                  _floorBloc.add(GetListFloorEvent());
                  _tabBarView =
                      TabBarView(controller: _tabBarController, children: List.generate(_listRoomModels.length, (index) => SubHomeListParamGroupByRoom()));
                }
              },
            ),
            BlocListener<FloorBloc, FloorState>(
              bloc: _floorBloc,
              listener: (context, state) {
                if (state is GetListFloorSuccessState) {
                  _listFloorModels = state.listFloorModels;
                  _currentFloorModel = _listFloorModels.first;
                  _roomBloc.add(const GetListRoomsByFloorIdEvent(null));
                }
              },
            ),
            BlocListener<RoomBloc, RoomState>(
              bloc: _roomBloc,
              listener: (context, state) {
                if (state is GetListRoomByFloorIdState) {
                  _listRoomModels = state.listRoomModels;
                  _tabBarController.dispose();
                  _tabBarController = TabController(length: _listRoomModels.length, vsync: this);
                  _deviceManagerBloc.add(GetListDeviceInAccountDeviceEvent());
                }
              },
            ),
            BlocListener<DeviceManagerBloc, DeviceManagerState>(
                bloc: _deviceManagerBloc,
                listener: (context, state) {
                  if (state is GetListDeviceInAccountDeviceSuccessState) {
                    Widget tempWidget = _tabBarView.children.first;
                    _listDevice = state.listDevice;
                    for (Widget widget in _tabBarView.children) {
                      if (widget is SubHomeListParamGroupByRoom) {
                        widget.changeListDevice(_listDevice);
                      }
                    }
                    _mqttBloc.subAllTopicListDevice();
                    setState(() {});
                  } else if (state is GetListDeviceInAccountDeviceFailState) {}
                }),
          ],
          child: _buildListRoomLayout(),
        ),
      ),
    );
  }

  Widget _buildListRoomLayout() {
    return Column(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _listRoomTitleLayout(),
          ),
        ),
        Expanded(child: _tabBarView) ?? Container()
      ],
    );
  }

  Widget _headerHomeLayout() {
    return Stack(
      children: [
        _backgroundImageSliverAppBar(),
        Column(
          children: [
            _sosButtonLayout(),
            const SizedBox(
              height: AppSize.a8,
            ),
            _listBuildingItemLayout()
          ],
        )
      ],
    );
  }

  Widget _backgroundImageSliverAppBar() {
    return Assets.images.backgroundHome.image(fit: BoxFit.fill, width: MediaQuery.of(context).size.width);
  }

  Widget _listBuildingItemLayout() {
    double itemWidth = AppSize.a88;
    double itemPadding = AppPadding.p14;
    double constrainedWidth = _listBuildingModels.length * (itemWidth + itemPadding) < MediaQuery.of(context).size.width - AppPadding.p34
        ? _listBuildingModels.length * (itemWidth + itemPadding)
        : MediaQuery.of(context).size.width - AppPadding.p34;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.22),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSize.a12), bottomLeft: Radius.circular(AppSize.a12))),
          padding: const EdgeInsets.only(top: AppPadding.p6, bottom: AppPadding.p6, left: AppPadding.p8),
          child: SizedBox(
            width: constrainedWidth,
            height: 100,
            child: ListView.builder(
              itemCount: _listBuildingModels.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: index == _listBuildingModels.length - 1 ? 0 : itemPadding),
                  child: _buildingItemLayout(_listBuildingModels[index], itemWidth),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildingItemLayout(BuildingModel buildingModel, double itemWidth) {
    return Container(
      width: itemWidth,
      padding: const EdgeInsets.only(left: AppPadding.p4, right: AppPadding.p4, top: AppPadding.p4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSize.a8), color: AppColors.white),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.a8),
            child: buildingModel.imageUrl != null && buildingModel.imageUrl != ''
                ? Image.network(buildingModel.imageUrl!, width: AppSize.a70, height: AppSize.a50, fit: BoxFit.cover)
                : Assets.images.buildingDefaultImg.image(
                    width: AppSize.a70,
                    height: AppSize.a50,
                  ),
          ),
          const SizedBox(
            height: AppSize.a8,
          ),
          Text(
            buildingModel.name ?? "",
            style: AppFonts.titleHeaderBold(fontSize: AppSize.a10, color: AppColors.primaryText),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
      ),
    );
  }

  Widget _subHeaderTabLayout() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.orangee,
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p14, horizontal: AppPadding.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonShowListFloorLayout(),
          const SizedBox(
            width: AppSize.a12,
          ),
          Expanded(
            child: HighLightButton(
              title: '${S.current.lost_connected}: 1',
              buttonColor: AppColors.white,
              textStyle: AppFonts.title(color: AppColors.primaryText),
              onPress: () {},
            ),
          ),
          const SizedBox(
            width: AppSize.a12,
          ),
          Expanded(
            child: HighLightButton(
              title: 'PIN yếu: 0',
              buttonColor: AppColors.white,
              textStyle: AppFonts.title(color: AppColors.primaryText),
              onPress: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonShowListFloorLayout() {
    return Expanded(
      child: DropdownButton2<FloorModel>(
        isExpanded: true,
        underline: const SizedBox(),
        value: _currentFloorModel,
        items: _listFloorModels
            .map((floorModel) => DropdownMenuItem(
                value: floorModel,
                child: Text(
                  floorModel.name ?? "",
                  style: AppFonts.title(color: AppColors.primaryText, fontSize: AppSize.a12),
                )))
            .toList(),
        onChanged: (value) {
          setState(() {
            if (value != null) {
              _currentFloorModel = value;
            }
          });
        },
        buttonStyleData: _dropdownStyle(),
        menuItemStyleData: _menuStyle(),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down, size: AppSize.a20, color: AppColors.secondaryText),
          openMenuIcon: Icon(Icons.keyboard_arrow_up, size: AppSize.a20, color: AppColors.secondaryText),
        ),
      ),
    );
  }

  List<Widget> _listRoomTitleLayout() {
    List<Widget> listRoomWidget = [];
    double spacing = AppSize.a24;
    for (var i = 0; i < _listRoomModels.length; i++) {
      listRoomWidget.add(_roomItem(i));
      if (i != _listRoomModels.length - 1) {
        listRoomWidget.add(SizedBox(width: spacing));
      }
    }
    return listRoomWidget;
  }

  Widget _roomItem(int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            // _buttonTap = true;
            _tabBarController.animateTo(index);
            // _setCurrentIndex(index);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: AppPadding.p8),
          child: Column(
            children: <Widget>[
              Text(
                _getRoomName(_listRoomModels[index]),
                style: TextStyle(fontSize: 14, color: _getForegroundColor(index), fontWeight: index == _currentIndex ? FontWeight.w600 : FontWeight.w400),
              ),
              const SizedBox(
                height: AppSize.a4,
              ),
              Visibility(
                visible: index == _currentIndex,
                child: Container(
                    width: AppSize.a24,
                    height: AppSize.a2,
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(1.5))),
              )
            ],
          ),
        ));
  }

  Widget _sosButtonLayout() {
    double statusBarHeight = MediaQuery.of(context).padding.top + AppPadding.p8;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(right: AppPadding.p16, top: statusBarHeight),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.sosButton, width: 1.5),
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          width: AppSize.a32,
          height: AppSize.a32,
          child: Center(
              child: Text(
            'SOS',
            style: AppFonts.titleHeaderBold(fontSize: AppSize.a10, color: AppColors.errorPrimary),
          )),
        ),
      ],
    );
  }

  _getRoomName(RoomModel room) {
    if (room.id == null) {
      return "all_device";
    } else {
      return room.name;
    }
  }

  _getForegroundColor(int index) {
    if (index == _currentIndex) {
      return AppColors.orangee;
    } else {
      return AppColors.secondaryText;
    }
  }

  ButtonStyleData _dropdownStyle() {
    return ButtonStyleData(
      height: AppSize.a50,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.a8),
      ),
    );
  }

  MenuItemStyleData _menuStyle() {
    return const MenuItemStyleData(
      height: AppSize.a48,
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
    );
  }
}
