
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final bool isUpperCaseTitle;
  final String title;
  final String? subtitle;
  final bool isShowSubtitle;
  final Widget? leading;
  final bool isShowBackButton;
  final List<Widget>? actions;
  final bool isCenterTitle;

  const CustomAppBarWidget({
    this.title = "",
    this.actions,
    this.leading,
    this.isShowBackButton = true,
    this.backgroundColor,
    this.isCenterTitle = false,
    this.isUpperCaseTitle = true,
    this.subtitle,
    this.isShowSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AppBar(
      leading: isShowBackButton
          ? leading ??
          IconButton(
            icon: Icon(Icons.chevron_left, size: 32, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: backgroundColor ?? Theme.of(context).primaryColor,
          )
          : null,
      automaticallyImplyLeading: isShowBackButton,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(isUpperCaseTitle ? title.toUpperCase() : title, style: AppFonts.titleHeaderBold(fontSize: AppSize.a16)),
          if (isShowSubtitle)
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(subtitle ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white)),
            ),
        ],
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ?? theme.primaryColor,
      elevation: 0.0,
      actions: actions,
      // brightness: Brightness.light,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}