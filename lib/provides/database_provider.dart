import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/model/building_model.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/device_param_model.dart';
import 'package:fire_alarm_app/model/share_building_model.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:hive/hive.dart';

class DatabaseHelper {
  static const accountBoxName = "account";
  static const buildingBoxName = "building";
  static const floorBoxName = "floor";
  static const roomBoxName = "room";
  static const deviceBoxName = "device";
  static const shareBuildingBoxName = "shareBuilding";

  static const paramGroupBoxName = "paramGroup";
  static const automationBoxName = "automation";
  static const cloudAutomationBoxName = "cloudAutomation";
  static const irRemoteInstanceDtoBoxName = "irRemoteInstanceDtoBoxName";
  static const eventBoxName = "eventBoxName";
  static const settingDataBoxName = "settingDataBoxName";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future initDatabase() async {
    Hive.registerAdapter(AccountAdapter());
    await Hive.openBox<Account>(accountBoxName);

    Hive.registerAdapter(BuildingModelAdapter());
    await Hive.openBox<BuildingModel>(buildingBoxName);

    Hive.registerAdapter(DeviceAdapter());
    await Hive.openBox<Device>(deviceBoxName);

    Hive.registerAdapter(ShareBuildingModelAdapter());
    await Hive.openBox<ShareBuildingModel>(shareBuildingBoxName);
  }

  Future<int> addOrUpdateAccount(Account account) async {
    var accountBox = Hive.box<Account>(accountBoxName);
    await accountBox.put(account.id, account);
    return 1;
  }

  Future<void> cleanDatabase() async {
    Hive.box<Account>(accountBoxName).clear();
  }

  Future<Account?> getAccountWithId(int accountId) async {
    var accountBox = Hive.box<Account>(accountBoxName);
    return accountBox.get(accountId);
  }

  Future<int> updateAccount(Account account) async {
    var accountBox = Hive.box<Account>(accountBoxName);
    await accountBox.put(account.id, account);
    return 1;
  }

  Future<int> deleteAccount(int? id) async {
    var accountBox = Hive.box<Account>(accountBoxName);
    accountBox.delete(id);
    return 1;
  }

  Future<int> deleteAllDevice() async {
    var deviceBox = Hive.box<Device>(deviceBoxName);
    return await deviceBox.clear();
  }

  Future<int> removeDevice(Device device) async {
    var deviceBox = Hive.box<Device>(deviceBoxName);
    await deviceBox.delete(device.id);
    return 1;
  }

  Future<int> addOrUpdateBuilding(BuildingModel buildingModel) async {
    var homeBox = Hive.box<BuildingModel>(buildingBoxName);
    await homeBox.put(buildingModel.id, buildingModel);
    return 1;
  }

  Future<List<dynamic>> addOrUpdateListShareBuilding(List<ShareBuildingModel> listShareBuildingModels) async {
    var sharedBox = Hive.box<ShareBuildingModel>(shareBuildingBoxName);
    await sharedBox.clear();
    listShareBuildingModels.forEach((homeShare) async {
      await sharedBox.put(homeShare.id, homeShare);
    });

    return listShareBuildingModels;
  }

  Future<int> addOrUpdateShareBuilding(ShareBuildingModel homeSharedModel) async {
    var sharedBox = Hive.box<ShareBuildingModel>(shareBuildingBoxName);
    await sharedBox.put(homeSharedModel.id, homeSharedModel);
    return 1;
  }

  Future<int> removeBuildingShareAccount(int? homeSharedId) async {
    var sharedBox = Hive.box<ShareBuildingModel>(shareBuildingBoxName);
    sharedBox.delete(homeSharedId);
    return 1;
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  getAllDevices() {
    var deviceBox = Hive.box<Device>(deviceBoxName);
    List<Device> objects = deviceBox.values.toList();
    return objects;
  }

  Future<bool> updateListDevices(List<Device> devices) async {
    var deviceBox = Hive.box<Device>(deviceBoxName);
    devices.forEach((device) async {
      await deviceBox.put(device.id, device);
    });
    return true;
  }

  getListDeviceWithTopic(String? topic) {
    var deviceBox = Hive.box<Device>(deviceBoxName);
    List<Device> objects = deviceBox.values.where((element) => element.topicContent == topic).toList();
    updateDeviceJsonToObject(objects);
    return objects;
  }

  updateDeviceJsonToObject(List<Device> objects) {
    for (Device d in objects) {
      if (!Common.checkNullOrEmpty(d.paramsJson) && Common.checkNullOrEmpty(d.params)) {
        d.params = deviceParamModelFromJson(d.paramsJson!);
      }
      if (d.meshConfig != null && d.meshConfigModel == null) {
        d.meshConfigModel = meshConfigModelFromJson(d.meshConfig!);
      }
    }
  }

  Future<int> updateDevice(Device device) async {
    var deviceBox = Hive.box<Device>(deviceBoxName);
    await deviceBox.put(device.id, device);
    return 1;
  }

}
