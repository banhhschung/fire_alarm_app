

import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppFonts{
  static const String beVietNamProMedium = 'BeVietnamPro-Medium';
  static const String beVietNamProSemiBoldItalic = 'BeVietnamPro-SemiBoldItalic';

  static TextStyle titleHeaderBold({double fontSize = 24, Color color = AppColors.white}) => TextStyle(
    fontFamily: beVietNamProMedium,
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w500,
    height: 32 / fontSize
  );

  static TextStyle title({double fontSize = 14, Color color = AppColors.title}) => TextStyle(
    fontFamily: beVietNamProMedium,
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w400,
  );

  static TextStyle title2({double fontSize = 20, Color color = AppColors.title}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w500,
      height: 28 / fontSize
  );

  static TextStyle title3({double fontSize = 14, Color color = AppColors.title}) => TextStyle(
    fontFamily: beVietNamProMedium,
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w500,
    height: 24 / fontSize
  );

  static TextStyle title5({double fontSize = 14, Color color = AppColors.primaryText}) => TextStyle(
    fontFamily: beVietNamProMedium,
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w500,
    height: 22 / fontSize
  );

  static TextStyle title6({double fontSize = 14, Color color = AppColors.secondaryText}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w400,
      height: 22 / fontSize
  );

  static TextStyle normalText({double fontSize = 14, Color color = AppColors.primaryText}) => TextStyle(
    fontFamily: beVietNamProMedium,
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w400,
  );

  static TextStyle hintText({double fontSize = 14, Color color = AppColors.secondaryText}) => TextStyle(
    fontFamily: beVietNamProMedium,
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w400,
  );

  static TextStyle buttonText({double fontSize = 14, Color color = AppColors.greyText}) => TextStyle(
    fontFamily: beVietNamProMedium,
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w400,
      height: 22 / fontSize
  );

  static TextStyle subTitle({double fontSize = 12, Color color = AppColors.title}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w400,
      height: 16 / fontSize
  );

  static TextStyle subTitle2({double fontSize = 14, Color color = AppColors.primaryText}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w400,
      height: 16 / fontSize
  );

  static TextStyle subTitle3({double fontSize = 12, Color color = AppColors.secondaryText}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w400,
      height: 16 / fontSize
  );

  static TextStyle buttonText2({double fontSize = 14, Color color = AppColors.primaryText}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w400,
      height: 22 / fontSize
  );

  static TextStyle buttonText3({double fontSize = 12, Color color = AppColors.primaryText}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w400,
      height: 16 / fontSize
  );

  static TextStyle body2({double fontSize = 14, Color color = AppColors.title}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w400,
      height: 22 / fontSize
  );

  static TextStyle deviceStatusText({double fontSize = 11, Color color = AppColors.title}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w700,
      height: 17 / fontSize
  );

  static TextStyle deviceNameText({double fontSize = 12, Color color = AppColors.title}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w500,
      height: 16 / fontSize
  );

  static TextStyle emergencyFireAlarmPCCCCenterDetailPage({double fontSize = 7, Color color = AppColors.white}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w600,
      height: 11 / fontSize
  );

  static TextStyle datetimePickerPopup({double fontSize = 17, Color color = AppColors.title}) => TextStyle(
      fontFamily: beVietNamProMedium,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w400,
  );
}

