
import 'package:fire_alarm_app/commons/extension.dart';

abstract interface class AppConstant {
  //* Duration
  static final zero = 0.ms;
  static final duration50ms = 50.ms;
  static final duration100ms = 100.ms;
  static final duration200ms = 200.ms;
  static final duration300ms = 300.ms;
  static final duration400ms = 400.ms;
  static final duration500ms = 500.ms;
  static final duration600ms = 600.ms;
  static final duration700ms = 700.ms;
  static final duration800ms = 800.ms;
  static final duration900ms = 900.ms;
  static final duration1s = 1.seconds;
  static final duration2s = 2.seconds;
  static final duration3s = 3.seconds;
  static final duration4s = 4.seconds;
  static final duration5s = 5.seconds;
  static final duration6s = 6.seconds;
  static final duration7s = 7.seconds;
  static final duration8s = 8.seconds;
  static final duration9s = 9.seconds;
  static final duration10s = 10.seconds;
  static final duration20s = 20.seconds;
  static final duration30s = 30.seconds;

  //* app Sound
  static List<SoundModel> LIST_ALERT_SOUND = [
    SoundModel(fileName: "iut_paris8_diallo_mariata_dangeralert", androidChannelId: "custom_notification1"),
    SoundModel(fileName: "thegreatbelow_security_alarm", androidChannelId: "custom_notification2"),
    SoundModel(fileName: "nahlin83_alarm", androidChannelId: "custom_notification3"),
    SoundModel(fileName: "miscpractice_emergency_alarm", androidChannelId: "custom_notification4"),
    SoundModel(fileName: "zerono1_alarm_car_or_home", androidChannelId: "custom_notification5"),
    SoundModel(fileName: "chuong_bao_chay", androidChannelId: "custom_notification6"),
    SoundModel(fileName: "vconnex_brand_sound", androidChannelId: "brand_sound"),
  ];
}

class SoundModel {
  String fileName;
  String androidChannelId;

  SoundModel({required this.fileName, required this.androidChannelId});
}
