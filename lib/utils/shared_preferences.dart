import 'dart:async';
import 'package:hive/hive.dart';

class SpUtil {

  static final sharedPrefBoxName = "sharedPrefBoxName";
  static SpUtil? _instance;
  static Future<SpUtil?> get instance async {
    return await getInstance();
  }

  SpUtil._();
  Future _init() async {
    await Hive.openBox(sharedPrefBoxName);
  }

  static Future<SpUtil?> getInstance() async  {
    if (_instance == null) {
      _instance = new SpUtil._();
      await _instance!._init();
    }
    return _instance;
  }

  bool hasKey(String key) {
    var sharedPrefBox = Hive.box(sharedPrefBoxName);
    return sharedPrefBox.containsKey(key);
  }

  Set<String?> getKeys() {
    return Hive.box(sharedPrefBoxName).keys as Set<String?>;
  }

  get(String key) {
   return Hive.box(sharedPrefBoxName).get(key);
  }

  String? getString(String? key) {
    return Hive.box(sharedPrefBoxName).get(key);
  }

  Future<bool> putString(String key, String? value) async {
    var sharedPrefBox = Hive.box(sharedPrefBoxName);
    await sharedPrefBox.put(key, value);
    return true;
  }

  bool? getBool(String key) {
    return  Hive.box(sharedPrefBoxName).get(key);
  }

  Future<bool> putBool(String key, bool? value) async {
    var sharedPrefBox = Hive.box(sharedPrefBoxName);
    await sharedPrefBox.put(key, value);
    return true;
  }

  int? getInt(String key) {
    return  Hive.box(sharedPrefBoxName).get(key);
  }

  Future<bool> putInt(String key, int? value) async {
    var sharedPrefBox = Hive.box(sharedPrefBoxName);
    await sharedPrefBox.put(key, value);
    return true;
  }

  double? getDouble(String key) {
    return  Hive.box(sharedPrefBoxName).get(key);
  }

  Future<bool> putDouble(String key, double value) async {
    var sharedPrefBox = Hive.box(sharedPrefBoxName);
    await sharedPrefBox.put(key, value);
    return true;
  }

  List<String>? getStringList(String key) {
    return  Hive.box(sharedPrefBoxName).get(key);
  }

  Future<bool> putStringList(String key, List<String> value) async {
    var sharedPrefBox = Hive.box(sharedPrefBoxName);
    await sharedPrefBox.put(key, value);
    return true;
  }

  dynamic getDynamic(String key) {
    return  Hive.box(sharedPrefBoxName).get(key);
  }

  Future<bool> remove(String key) async {
    var sharedPrefBox = Hive.box(sharedPrefBoxName);
    await sharedPrefBox.delete(key);
    return true;
  }

  Future<bool> clear() async {
   await Hive.box(sharedPrefBoxName).clear();
   return true;
  }

}