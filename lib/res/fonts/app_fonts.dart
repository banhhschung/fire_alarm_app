

import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppFonts{
  static const String beVietNamProMedium = 'BeVietnamPro-Medium';
  static const String beVietNamProSemiBoldItalic = 'BeVietnamPro-SemiBoldItalic';

  static TextStyle titleBold([double fontSize = 14, Color color = AppColors.black]) => TextStyle(
    fontFamily: beVietNamProMedium,
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w400,
  );
}