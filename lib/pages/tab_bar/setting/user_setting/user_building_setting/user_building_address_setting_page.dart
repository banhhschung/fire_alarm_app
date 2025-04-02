import 'dart:convert';
import 'dart:ffi';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fire_alarm_app/blocs/location_bloc/location_bloc.dart';
import 'package:fire_alarm_app/blocs/location_bloc/location_event.dart';
import 'package:fire_alarm_app/blocs/location_bloc/location_state.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/building_location_model.dart';
import 'package:fire_alarm_app/model/building_model.dart';
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

class UserBuildingAddressSettingPage extends StatefulWidget {
  final BuildingModel buildingModel;

  const UserBuildingAddressSettingPage({super.key, required this.buildingModel});

  @override
  State<StatefulWidget> createState() => _UserBuildingAddressSettingPageState();
}

class _UserBuildingAddressSettingPageState extends State<UserBuildingAddressSettingPage> {
  late LocationBloc _locationBloc;

  late List<ProvinceModel> _listProvinces = [];
  late ProvinceModel _currentProvince = ProvinceModel();

  late List<DistrictModel> _listDistricts = [];
  late DistrictModel _currentDistrict = DistrictModel();

  late BuildingModel _buildingModel;

  late bool _isShowProcess = false;
  late TextEditingController _detailBuildingLocationTextEditingController = TextEditingController();

  @override
  void initState() {
    _buildingModel = widget.buildingModel;
    _locationBloc = LocationBloc()..add(GetListProvinceLocationEvent());
    _toggleProcess(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: S.current.address,
      ),
      body: BlocListener<LocationBloc, LocationState>(
          bloc: _locationBloc,
          listener: (context, state) {
            _toggleProcess(false);
            if (state is GetListProvinceLocationSuccessState) {
              _listProvinces = state.listProvinceModel;
              if (_listProvinces.isNotEmpty) {
                if (_buildingModel.id != null && _buildingModel.provinceId != null) {
                  _currentProvince = _listProvinces.firstWhere((element) => element.id == _buildingModel.provinceId, orElse: () => _listProvinces.first);
                  _locationBloc.add(GetListDistrictLocationEvent(provinceId: _currentProvince.id!));
                  _toggleProcess(true);
                } else {
                  _currentProvince = _listProvinces.first;
                  _locationBloc.add(GetListDistrictLocationEvent(provinceId: _currentProvince.id!));
                  _toggleProcess(true);
                }
              }
              setState(() {});
            } else if (state is GetListProvinceLocationFailState) {
            } else if (state is GetListDistrictLocationSuccessState) {
              _listDistricts = state.listDistrictModel;
              if (_listDistricts.isNotEmpty) {
                if (_buildingModel.id != null && _buildingModel.districtId != null) {
                  _currentDistrict = _listDistricts.firstWhere((element) => element.id == _buildingModel.districtId, orElse: () => _listDistricts.first);
                } else {
                  _currentDistrict = _listDistricts.first;
                }
              }
            } else if (state is GetListDistrictLocationFailState) {}
          },
          child: _buildBuildingAddressLayout()),
    );
  }

  Widget _buildBuildingAddressLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [_buildSettingAddressBuildingLayout()],
              ),
            ),
            HighLightButton(
                onPress: () {
                  _saveBuildingLocationInformationFunction();
                },
                title: S.current.save_information)
          ],
        ),
      ),
    );
  }

  Widget _buildSettingAddressBuildingLayout() {
    return Column(
      children: [
        _buildDropdownProvinceCityAddressLayout(),
        const SizedBox(
          height: AppSize.a16,
        ),
        _buildDropdownDistrictTownAddressLayout(),
        const SizedBox(
          height: AppSize.a16,
        ),
        _buildSpecificAddressLayout()
      ],
    );
  }

  Widget _buildDropdownDistrictTownAddressLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.district_town,
          style: AppFonts.title(fontSize: AppSize.a16, color: AppColors.title),
        ),
        const SizedBox(
          height: AppSize.a4,
        ),
        DropdownButton2<DistrictModel>(
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text("${S.current.choose} ${S.current.district_town}"),
          value: _currentDistrict,
          items: _listDistricts.map((element) => DropdownMenuItem(value: element, child: Text(element.name ?? ""))).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _currentDistrict = value;
              });
            }
          },
          buttonStyleData: _dropdownStyle(),
          menuItemStyleData: _menuStyle(),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down, size: AppSize.a20, color: AppColors.secondaryText),
            openMenuIcon: Icon(Icons.keyboard_arrow_up, size: AppSize.a20, color: AppColors.secondaryText),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownProvinceCityAddressLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.province_city,
          style: AppFonts.title(fontSize: AppSize.a16, color: AppColors.title),
        ),
        const SizedBox(
          height: AppSize.a4,
        ),
        DropdownButton2<ProvinceModel>(
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text("${S.current.choose} ${S.current.province_city}"),
          value: _currentProvince,
          items: _listProvinces.map((element) => DropdownMenuItem(value: element, child: Text(element.name ?? ""))).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _currentProvince = value;
              });
              _locationBloc.add(GetListDistrictLocationEvent(provinceId: _currentProvince.id!));
              _toggleProcess(true);
            }
          },
          buttonStyleData: _dropdownStyle(),
          menuItemStyleData: _menuStyle(),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down, size: AppSize.a20, color: AppColors.secondaryText),
            openMenuIcon: Icon(Icons.keyboard_arrow_up, size: AppSize.a20, color: AppColors.secondaryText),
          ),
        ),
      ],
    );
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

  Widget _buildSpecificAddressLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFieldWidget(
          hintText: "${S.current.enter} ${S.current.specific_address.toLowerCase()}",
          titleInput: S.current.specific_address,
          controller: _detailBuildingLocationTextEditingController,
        )
      ],
    );
  }

  Future<void> _saveBuildingLocationInformationFunction() async {
    if (_detailBuildingLocationTextEditingController.text.trim().isNotEmpty) {
      _toggleProcess(true);
      if (await Common.isConnectToServer()) {
        if (_currentProvince.id != null && _currentDistrict.id != null) {
          BuildingLocationModel buildingLocationModel = BuildingLocationModel(
              provinceId: _currentProvince.id,
              provinceCode: _currentProvince.name,
              districtId: _currentDistrict.id,
              address: _detailBuildingLocationTextEditingController.text);
          Navigator.of(context).pop(buildingLocationModel);
        } else {
          _toggleProcess(true);
          Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
        }
      } else {
        _toggleProcess(true);
        Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
      }
    } else {
      Common.showSnackBarMessage(context, S.current.you_need_to_enter_the_building_address, isError: true);
    }
  }

  _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}

ProvinceModel provinceModelFromJson(String str) => ProvinceModel.fromJson(json.decode(str));

String provinceModelToJson(ProvinceModel data) => json.encode(data.toJson());

class ProvinceModel {
  int? id;
  String? name;
  int? countryId;
  String? contents;
  String? modifiedDate;

  ProvinceModel({
    this.id,
    this.name,
    this.countryId,
    this.contents,
    this.modifiedDate,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
        id: json["id"],
        name: json["name"],
        countryId: json["countryId"],
        contents: json["contents"],
        modifiedDate: json["modifiedDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "countryId": countryId,
        "contents": contents,
        "modifiedDate": modifiedDate,
      };
}

DistrictModel districtModelFromJson(String str) => DistrictModel.fromJson(json.decode(str));

String districtModelToJson(DistrictModel data) => json.encode(data.toJson());

class DistrictModel {
  int? id;
  String? name;
  int? provinceId;
  String? code;
  String? type;
  double? lat;
  double? lon;

  DistrictModel({
    this.id,
    this.name,
    this.provinceId,
    this.code,
    this.type,
    this.lat,
    this.lon,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        id: json["id"],
        name: json["name"],
        provinceId: json["provinceId"],
        code: json["code"],
        type: json["type"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "provinceId": provinceId,
        "code": code,
        "type": type,
        "lat": lat,
        "lon": lon,
      };
}
