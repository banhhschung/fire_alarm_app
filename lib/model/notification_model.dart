import 'dart:convert';

import 'package:fire_alarm_app/utils/common_utils.dart';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromMap(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toMap());

class NotificationModel {
  int? id;
  String? title;
  String? content;
  String? dateTime;
  int? typeAlert;
  bool? isDelete;
  String? contentHtml;
  String? imageUrl;
  String? imagePopupUrl;
  String? linkForward;
  String? titleButton;

  NotificationModel({
    this.title,
    this.id,
    this.content,
    this.dateTime,
    this.typeAlert,
    this.contentHtml,
    this.imageUrl,
    this.imagePopupUrl,
    this.linkForward,
    this.titleButton,
    this.isDelete = false,
    // this.idOfDevice
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) => NotificationModel(
    title: json["data"],
    id: json["id"],
    content: json["content"],
    dateTime: json["dateTime"],
    typeAlert: json["typeAlert"],
    contentHtml: json["contentHtml"],
    imageUrl: json["imageUrl"],
    imagePopupUrl: json["imagePopupUrl"],
    linkForward: json["linkForward"],
    titleButton: json["titleButton"],
  );

  factory NotificationModel.fromBackEndMap(Map<String, dynamic> json) => NotificationModel(
    id: json["id"],
    title: json["data"]?? json["title"] ?? '',
    content: json["content"]?? '',
    dateTime: _getDateTime(json["createdDate"]),
    typeAlert: json["typeAlert"],
    contentHtml: json["contentHtml"],
    imageUrl: json["imageUrl"],
    imagePopupUrl: json["imagePopupUrl"],
    linkForward: json["linkForward"],
    titleButton: json["titleButton"],
  );

  static String _getDateTime(int value){
    return Common.convertTimestampToTimeHHmmSSDDMMYYYY(value);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "content": content,
    "dateTime": dateTime,
    "contentHtml": contentHtml,
    "imageUrl": imageUrl,
    "imagePopupUrl": imagePopupUrl,
    "linkForward": linkForward,
    "titleButton": titleButton,
  };
}