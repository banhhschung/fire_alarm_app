import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/pages/tab_bar/diagram/diagram_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/home/home_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/notification/notification_history_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/setting_page.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class TabBarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  final List<Widget> _pages = [HomePage(), DiagramPage(), NotificationHistoryPage(), SettingPage()];

  int _currentIndex = 0;

  void _onSelectBarItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.orangee,
        unselectedItemColor: AppColors.secondaryText,
        selectedLabelStyle: AppFonts.title(fontSize: AppSize.a10, color: AppColors.orangee),
        unselectedLabelStyle: AppFonts.title(fontSize: AppSize.a10, color: AppColors.secondaryText),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: _customNavigatorBarItem(ImageIcon(AssetImage(Assets.images.homeTabbarIcon.path))),
            activeIcon: _customNavigatorBarItem(ImageIcon(AssetImage(Assets.images.homeTabbarIcon.path))),
            label: "Danh sách",
          ),
          BottomNavigationBarItem(
            icon: _customNavigatorBarItem(ImageIcon(AssetImage(Assets.images.diagramTabbarIcon.path))),
            activeIcon: _customNavigatorBarItem(ImageIcon(AssetImage(Assets.images.diagramTabbarIcon.path))),
            label: "Mô hình",
          ),
          BottomNavigationBarItem(
            icon: _customNavigatorBarItem(ImageIcon(AssetImage(Assets.images.notificationHistoryTabbarIcon.path))),
            activeIcon: _customNavigatorBarItem(ImageIcon(AssetImage(Assets.images.notificationHistoryTabbarIcon.path))),
            label: "Thông báo",
          ),
          BottomNavigationBarItem(
            icon: _customNavigatorBarItem(ImageIcon(AssetImage(Assets.images.settingTabbarIcon.path))),
            activeIcon: _customNavigatorBarItem(ImageIcon(AssetImage(Assets.images.settingTabbarIcon.path))),
            label: "Cài đặt",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onSelectBarItem,
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
    );
  }

  _customNavigatorBarItem(ImageIcon icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.p4),
      child: icon,
    );
  }
}
