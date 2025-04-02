import 'dart:convert';

import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/model/login_data_model.dart';
import 'package:hive/hive.dart';

part 'adapters/account_model.g.dart';
Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class Account extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? gender;

  @HiveField(2)
  String? providerId;

  @HiveField(3)
  String? uuid;

  @HiveField(4)
  String? name;

  @HiveField(5)
  String? email;

  @HiveField(6)
  String? password;

  @HiveField(7)
  String? iconPath;

  @HiveField(8)
  String? birthDay;

  @HiveField(9)
  String? phone;

  @HiveField(10)
  String? address;

  @HiveField(11)
  String? provinceCode;

  @HiveField(12)
  String? lat;

  @HiveField(13)
  String? lon;

  @HiveField(14)
  int? provinceId;

  @HiveField(15)
  String? weatherContent;

  @HiveField(16)
  int? districtId;

  @HiveField(17)
  String? districtName;

  @HiveField(18)
  String? phonePin;

  @HiveField(19)
  String? pin;

  @HiveField(20)
  int? statusOfPin;

  @HiveField(21)
  int? activeTimePin;

  ProviderMetadata? providerMetadata;

  Account(
      {this.id,
        this.gender,
        this.name,
        this.providerId,
        this.email,
        this.password,
        this.iconPath,
        this.birthDay,
        this.phone,
        this.address,
        this.uuid,
        this.provinceCode,
        this.lat,
        this.lon,
        this.provinceId,
        this.weatherContent,
        this.districtId,
        this.districtName,
        this.providerMetadata,
        this.phonePin,
        this.pin,
        this.statusOfPin,
        this.activeTimePin});

  Map<String, dynamic> toMap() {
    // map xuống DB
    Map<String, dynamic> map = {
      'id': id,
      'gender': gender,
      'pin': pin,
      'statusOfPin': statusOfPin,
      'phonePin': phonePin,
      'name': name,
      'providerId': providerId,
      'email': email,
      'password': password,
      'iconPath': iconPath,
      'birthDay': birthDay,
      'phone': phone,
      'address': address,
      'uuid': uuid,
      'provinceCode': provinceCode,
      'lat': lat,
      'lon': lon,
      'provinceId': provinceId,
      'weatherContent': weatherContent,
      'districtId': districtId,
      'districtName': districtName,
      'activeTimePin': activeTimePin
    };

    return map;
  }

  Map<String, dynamic> toBEMap() {
    // gửi lên BE
    Map<String, dynamic> map = {
      'id': id,
      'gender': gender,
      'name': name,
      'providerId': providerId,
      'password': password,
      'iconPath': iconPath,
      'birthDay': birthDay,
      'uuid': uuid,
      'provinceCode': provinceCode,
      'lat': lat,
      'lon': lon,
      'provinceId': provinceId,
      'weatherContent': weatherContent,
      'districtId': districtId,
      'districtName': districtName,
    };

    if (providerId == ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE) {
      map['email'] = email;
    } else if (providerId == ConfigApp.PROVIDER_LOGIN_PHONE_TYPE) {
      map['phone'] = phone;
    }

    if (providerMetadata != null) {
      String model = providerMetadataToJson(providerMetadata!);
      map['providerMetadata'] = model;
    }

    return map;
  }

  Account.fromMap(Map<String, dynamic> map) {
    // map từ DB
    id = map['id'];
    gender = map['gender'];
    pin = map['pin'] == null ? '' : map['pin'];
    statusOfPin = map['statusOfPin'];
    phonePin = map['phonePin'];
    name = map['name'];
    providerId = map['providerId'];
    email = map['email'];
    password = map['password'];
    iconPath = map['iconPath'];
    birthDay = map['birthDay'];
    phone = map['phone'];
    address = map['address'];
    uuid = map['uuid'];
    provinceCode = map['provinceCode'];
    lat = map['lat'];
    lon = map['lon'];
    provinceId = map['provinceId'];
    weatherContent = map['weatherContent'];
    districtId = map['districtId'];
    districtName = map['districtName'];
    activeTimePin = map['security'] == null ? null : map['security']['activeTimePin'];
  }

  factory Account.fromBEJson(Map<String, dynamic> jsonBE) {
    Account account = Account(
        id: jsonBE["id"],
        password: jsonBE["password"],
        name: jsonBE['name'] ?? '',
        phone: jsonBE["phonenumber"] ?? '',
        gender: jsonBE["sex"] ?? 0,
        birthDay: jsonBE["dayofbirth"] ?? '',
        address: jsonBE["address"] ?? '',
        uuid: jsonBE["uuid"] ?? '',
        providerId: jsonBE["provider"],
        email: jsonBE["email"] ?? '',
        pin: jsonBE["security"] == null ? '' : (jsonBE["security"]["pin"] == null ? '' : jsonBE["security"]["pin"]),
        activeTimePin: jsonBE["security"] == null ? null : (jsonBE["security"]["activeTimePin"] == null ? null : jsonBE["security"]["activeTimePin"]),
        statusOfPin: jsonBE["security"] == null ? -5 : (jsonBE["security"]["status"] == null ? -5 : jsonBE["security"]["status"]),
        phonePin: jsonBE["security"] == null ? '' : (jsonBE["security"]["phonenumber"] == null ? '' : jsonBE["security"]["phonenumber"]));
    if (jsonBE["provider"] == ConfigApp.PROVIDER_LOGIN_PHONE_TYPE) {
      account.phone = jsonBE["providerUserId"];
      account.iconPath = 'assets/images/default_avatar_ic.png';
    } else if (jsonBE["provider"] == ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE) {
      account.email = jsonBE["providerUserId"];
      account.iconPath = 'assets/images/default_avatar_ic.png';
    }

    if (jsonBE["providerMetadata"] != null) {
      try {
        Map<String, dynamic> map = json.decode(jsonBE["providerMetadata"]);
        ProviderMetadata providerMetadataModel = ProviderMetadata.fromMap(map);
        if (account.name != null && account.name!.isEmpty) {
          account.name = providerMetadataModel.name ?? '';
        }
        if (account.email != null && account.email!.isEmpty) {
          account.email = providerMetadataModel.email ?? '';
        }

        if (account.iconPath == null) {
          account.iconPath = providerMetadataModel.iconPath ?? 'assets/images/default_avatar_ic.png';
        }

        if (jsonBE["provider"] != ConfigApp.PROVIDER_LOGIN_PHONE_TYPE) {
          account.phone = providerMetadataModel.phoneDetail ?? '';
        }
      } catch (e) {
//        print(e);
      }
    } else {
      if (account.iconPath == null) {
        account.iconPath = 'assets/images/default_avatar_ic.png';
      }
    }

    if (jsonBE['userInforDto'] != null) {
      Map<String, dynamic> userInfo = jsonBE['userInforDto'];
      account.provinceCode = userInfo['provinceCode'];
      account.lat = userInfo['lat'].toString();
      account.lon = userInfo['lon'].toString();
      account.address = userInfo['address'];

      if (userInfo['province'] != null) {
        Map<String, dynamic> weatherInfo = userInfo['province'];
        account.weatherContent = weatherInfo['contents'];
        account.provinceId = weatherInfo['id'];
      }

      if (userInfo['district'] != null) {
        Map<String, dynamic> districtInfo = userInfo['district'];
        account.districtId = districtInfo['id'];
        account.districtName = districtInfo['name'];
      }
    }
    return account;
  }

  factory Account.fromBEToUpdateAccountJson(Map<String, dynamic> jsonBE) {
    Account account = Account(
        id: jsonBE["id"],
        password: jsonBE["password"],
        name: jsonBE['name'] ?? '',
        phone: jsonBE["phonenumber"] ?? '',
        gender: jsonBE["sex"] ?? 0,
        birthDay: jsonBE["dayofbirth"] ?? '',
        address: jsonBE["address"] ?? '',
        uuid: jsonBE["uuid"] ?? '',
        providerId: jsonBE["provider"],
        email: jsonBE["email"] ?? '',
        pin: jsonBE["security"]["pin"] ?? '',
        statusOfPin: jsonBE["security"]["status"],
        phonePin: jsonBE["security"]["phonenumber"] ?? '');

    if (jsonBE["providerMetadata"] != null) {
      try {
        Map<String, dynamic> map = json.decode(jsonBE["providerMetadata"]);
        ProviderMetadata providerMetadataModel = ProviderMetadata.fromMap(map);
        if (account.name != null && account.name!.isEmpty) {
          account.name = providerMetadataModel.name ?? '';
        }
        if (account.email != null && account.email!.isEmpty) {
          account.email = providerMetadataModel.email ?? '';
        }
        if (account.iconPath == null || account.iconPath == 'assets/images/default_avatar_ic.png') {
          account.iconPath = providerMetadataModel.iconPath ?? 'assets/images/default_avatar_ic.png';
        }
        if (jsonBE["provider"] != ConfigApp.PROVIDER_LOGIN_PHONE_TYPE) {
          account.phone = providerMetadataModel.phoneDetail ?? '';
        }
      } catch (e) {
//        print(e);
      }
    }

    if (jsonBE['userInforDto'] != null) {
      Map<String, dynamic> userInfo = jsonBE['userInforDto'];
      account.provinceCode = userInfo['provinceCode'];
      account.lat = userInfo['lat'].toString();
      account.lon = userInfo['lon'].toString();
      account.address = userInfo['address'];

      if (userInfo['province'] != null) {
        Map<String, dynamic> weatherInfo = userInfo['province'];
        account.weatherContent = weatherInfo['contents'];
        account.provinceId = weatherInfo['id'];
      }

      if (userInfo['district'] != null) {
        Map<String, dynamic> districtInfo = userInfo['district'];
        account.districtId = districtInfo['id'];
        account.districtName = districtInfo['name'];
      }
    }

    // if (jsonBE["security"] != null) {
    //   if (Common.checkNullOrEmpty(jsonBE["security"]["pin"])) {
    //     account.pin = jsonBE["security"]["pin"];
    //   }
    //   if (Common.checkNullOrEmpty(jsonBE["security"]["status"])) {
    //     account.statusOfPin = jsonBE["security"]["status"];
    //   }
    //   if (Common.checkNullOrEmpty(jsonBE["security"]['phonenumber'])) {
    //     account.phonePin = jsonBE["security"]["phonenumber"];
    //   }
    // }
    return account;
  }

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    // map tu DB
      id: json["id"],
      name: json["name"],
      gender: json["gender"],
      pin: json["pin"],
      statusOfPin: json["statusOfPin"],
      phonePin: json["phonePin"],
      providerId: json["providerId"],
      email: json["email"],
      password: json["password"],
      iconPath: json["iconPath"],
      birthDay: json["birthDay"],
      phone: json["phone"],
      address: json["address"],
      provinceCode: json["provinceCode"],
      lat: json["lat"],
      lon: json["lon"],
      districtId: json["districtId"],
      districtName: json["districtName"],
      provinceId: json["provinceId"],
      weatherContent: json["weatherContent"],
      uuid: json["uuid"],
      activeTimePin: json["activeTimePin"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "gender": gender,
    "pin": pin,
    "statusOfPin": statusOfPin,
    "phonePin": phonePin,
    "email": email,
    "providerId": providerId,
    "password": password,
    "iconPath": iconPath,
    "birthDay": birthDay,
    "phone": phone,
    "address": address,
    "uuid": uuid,
    "provinceCode": provinceCode,
    "lat": lat,
    "lon": lon,
    "districtId": districtId,
    "districtName": districtName,
    "provinceId": provinceId,
    "weatherContent": weatherContent,
    "activeTimePin": activeTimePin
  };
}

UpdateAccountData updateAccountDataFromJson(String str) => UpdateAccountData.fromMap(json.decode(str));

String updateAccountDataToJson(UpdateAccountData data) => json.encode(data.toMap());

class UpdateAccountData {
  int? id;
  String? name;
  String? dayofbirth;
  String? phonenumber;
  int? sex;
  String? email;
  String? address;
  String? providerMetadata;

  ProviderMetadata? providerMetadataModel;

  UpdateAccountData({
    this.id,
    this.name,
    this.dayofbirth,
    this.phonenumber,
    this.email,
    this.sex,
    this.address,
    this.providerMetadata,
    this.providerMetadataModel
  });

  factory UpdateAccountData.fromMap(Map<String, dynamic> json) => UpdateAccountData(
    id: json["id"],
    name: json["name"],
    dayofbirth: json["birthDay"],
    phonenumber: json["phone"],
    email: json["email"],
    sex: json["gender"],
    address: json["address"],
  );

  factory UpdateAccountData.fromAccountMap(Map<String, dynamic> jsonAc) {
    UpdateAccountData data =
    UpdateAccountData(
      id: jsonAc["id"],
      name: jsonAc["name"],
      dayofbirth: jsonAc["birthDay"],
      sex: jsonAc["gender"],
    );

    if(jsonAc["providerId"] == ConfigApp.PROVIDER_LOGIN_PHONE_TYPE){
      data.phonenumber = jsonAc["phone"];
    } else if(jsonAc["providerId"] == ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE){
      data.email = jsonAc["email"];
    }

    if(jsonAc["providerMetadata"] != null){
      data.providerMetadataModel = ProviderMetadata.fromMap(json.decode(jsonAc["providerMetadata"]));
    }

    return data;
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "dayofbirth": dayofbirth,
    "phonenumber": phonenumber,
    "email": email,
    "sex": sex,
    "address": address,
    "providerMetadata": providerMetadataModel == null? null : providerMetadataToJson(providerMetadataModel!)
  };
}

class RegisterAccountModel {
  String? provider;
  String? providerUserId;
  String? providerMetadata;
  String? password;
  int? lang;

  RegisterAccountModel(
      {this.provider,
        this.providerUserId,
        this.providerMetadata,
        this.password, this.lang});

  RegisterAccountModel.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    providerUserId = json['providerUserId'];
    providerMetadata = json['providerMetadata'];
    password = json['password'];
    lang = json['language'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(provider != null){
      data['provider'] = provider;
    }
    if(providerUserId != null){
      data['providerUserId'] = providerUserId;
    }
    if(providerMetadata != null){
      data['providerMetadata'] = providerMetadata;
    }
    if(password != null){
      data['password'] = password;
    }
    if(lang != null){
      data['language'] = lang;
    }
    return data;
  }
}