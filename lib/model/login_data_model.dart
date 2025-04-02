import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromMap(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toMap());

class LoginData {
  String? provider;
  String? providerUserId;
  String? password;
  String? checksum;
  String? deviceToken;
  String? appVersion;
  int? osSystem;
  int? language;
  String? deviceId;
  ProviderMetadata? providerMetadata;
  String? deviceName;
  String? deviceVersion;

  LoginData(
      {this.provider,
      this.providerUserId,
      this.password,
      this.checksum,
      this.deviceToken,
      this.osSystem,
      this.language,
      this.deviceId,
      this.providerMetadata,
      this.appVersion,
      this.deviceName,
      this.deviceVersion});

  factory LoginData.fromMap(Map<String, dynamic> json) {
    LoginData loginData = LoginData(
        provider: json["provider"],
        providerUserId: json["providerUserId"],
        password: json["password"],
        checksum: json["checksum"],
        deviceToken: json["deviceToken"],
        osSystem: json["osSystem"],
        language: json["language"],
        deviceId: json["deviceId"],
        providerMetadata: json["providerMetadata"],
        deviceName: json["deviceName"],
        deviceVersion: json["deviceVersion"]);

    return loginData;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['provider'] = provider;
    map['providerUserId'] = providerUserId;
    map['password'] = password;
    map['checksum'] = checksum;
    map['deviceToken'] = deviceToken;
    map['osSystem'] = osSystem;
    map['language'] = language;
    map['deviceId'] = deviceId;
    map['appVersion'] = appVersion;
    map['cameraRegionID'] = 'ap-southeast-1';
    map['deviceName'] = deviceName;
    map['deviceVersion'] = deviceVersion;

    if (providerMetadata != null) {
      String model = providerMetadataToJson(providerMetadata!);
      map['providerMetadata'] = model;
    }
    return map;
  }
}

ProviderMetadata providerMetadataFromJson(String str) => ProviderMetadata.fromMap(json.decode(str));

String providerMetadataToJson(ProviderMetadata data) => json.encode(data.toMap());

class ProviderMetadata {
  String? name;
  String? email;
  String? iconPath;
  String? phoneDetail;

  ProviderMetadata({this.name, this.email, this.iconPath, this.phoneDetail});

  factory ProviderMetadata.fromMap(Map<String, dynamic> json) => ProviderMetadata(
        name: json["name"],
        email: json["email"],
        iconPath: json["iconPath"],
        phoneDetail: json["phoneDetail"],
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (name != null) {
      data['name'] = name;
    }
    if (email != null) {
      data['email'] = email;
    }
    if (iconPath != null) {
      data['iconPath'] = iconPath;
    }
    if (phoneDetail != null) {
      data['phoneDetail'] = phoneDetail;
    }
    return data;
  }
}
