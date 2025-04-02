import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_event.dart';
import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_state.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class UserAddShareMemberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserAddShareMemberPageState();
}

class _UserAddShareMemberPageState extends State<UserAddShareMemberPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR_Add_Smoke');

  late ShareManagerBloc _shareManagerBloc;

  late QRViewController _qrViewController;
  final TextEditingController _shareCodeTextController = TextEditingController();

  late int _settingMemberType = ConfigApp.MEMBER_TYPE_RELATIVE;

  late bool _isShowProcess = false;

  @override
  void initState() {
    _shareManagerBloc = ShareManagerBloc();
    super.initState();
  }

  @override
  void dispose() {
    _qrViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: S.current.add_members,
      ),
      body: BlocListener<ShareManagerBloc, ShareManagerState>(
          bloc: _shareManagerBloc,
          listener: (BuildContext context, ShareManagerState state) {
            _toggleProcess(false);
            if (state is AddShareAccountSuccessState) {
              Common.showSnackBarMessage(context, S.current.add_member_successful);
              Future.delayed(const Duration(seconds: 3)).then((value) {
                Navigator.of(context).pop(true);
              });
            } else if (state is AddShareAccountFailState) {
              switch (state.errorCode) {
                case 8:
                  Common.showSnackBarMessage(context, S.current.add_member_successful, isError: true);
                  break;
                case 69:
                  Common.showSnackBarMessage(context, S.current.this_account_already_exists, isError: true);
                  break;
                default:
                  Common.showSnackBarMessage(context, S.current.sharing_failed_please_try_again, isError: true);
                  break;
              }
            }
          },
          child: _buildUserAddShareMemberLayout()),
    );
  }

  Widget _buildUserAddShareMemberLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppPadding.p16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildQRViewItemLayout(),
                  _buildTutorialStepToShareToMemberLayout(),
                  _buildSettingSharedMemberLayout(),
                  _buildShareAllDeviceToMemberLayout()
                ],
              ),
            ),
            HighLightButton(
                onPress: () {
                  _buildingSharingFunction();
                },
                title: S.current.add_share)
          ],
        ),
      ),
    );
  }

  Widget _buildQRViewItemLayout() {
    var sizeHeightQRView = MediaQuery.of(context).size.height / 4;
    return SizedBox(
      height: sizeHeightQRView,
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  Widget _buildTutorialStepToShareToMemberLayout() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.a8),
      ),
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Column(
        children: [
          Text(
            S.current.three_steps_to_open_the_shared_code_of_the_shared_member,
            style: AppFonts.title5(fontSize: AppSize.a16),
          ),
          const SizedBox(
            height: AppSize.a12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTutorialStepToShareItemLayout(S.current.open_app, Assets.images.stepOneToShareMemberImg.image()),
                _buildTutorialStepToShareItemLayout(S.current.select_menu, Assets.images.stepTwoToShareMemberImg.image()),
                _buildTutorialStepToShareItemLayout(S.current.click_qr_code, Assets.images.stepThreeToShareMemberImg.image()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialStepToShareItemLayout(String title, Image tutorialImage) {
    return Column(
      children: [
        Container(
          width: AppSize.a48,
          height: AppSize.a48,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: tutorialImage,
        ),
        const SizedBox(
          height: AppSize.a4,
        ),
        Text(
          title,
          style: AppFonts.subTitle2(fontSize: AppSize.a10),
        )
      ],
    );
  }

  Widget _buildSettingSharedMemberLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
      child: Column(
        children: [
          CustomTextFieldWidget(
            titleInput: S.current.shared_code,
            controller: _shareCodeTextController,
          ),
          const SizedBox(
            height: AppSize.a16,
          ),
          _buildTypeOfAccountLayout()
        ],
      ),
    );
  }

  Widget _buildTypeOfAccountLayout() {
    List<int> memberType = [ConfigApp.MEMBER_TYPE_RELATIVE, ConfigApp.MEMBER_TYPE_GUEST];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.account_type,
          style: AppFonts.title(fontSize: AppSize.a14, color: AppColors.title),
        ),
        const SizedBox(
          height: AppSize.a4,
        ),
        DropdownButton2<int>(
          isExpanded: true,
          underline: const SizedBox(),
          value: _settingMemberType,
          items: memberType
              .map((e) => DropdownMenuItem(value: e, child: Text(e == ConfigApp.MEMBER_TYPE_RELATIVE ? S.current.relatives : S.current.guest)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _settingMemberType = value as int;
            });
          },
          buttonStyleData: _dropdownStyle(),
          menuItemStyleData: _menuStyle(),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down, size: AppSize.a20, color: AppColors.secondaryText),
            openMenuIcon: Icon(Icons.keyboard_arrow_up, size: AppSize.a20, color: AppColors.secondaryText),
          ),
        ),
      ],
    );
  }

  Widget _buildShareAllDeviceToMemberLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo Column nằm trên cùng
        children: [
          _buildCheckBoxButtonLayout(),
          const SizedBox(width: AppSize.a8),
          Expanded(
            // Đảm bảo nội dung text không bị tràn
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.share_all_devices,
                  style: AppFonts.title6(),
                ),
                const SizedBox(height: AppSize.a2), // Dùng height thay vì width
                Text(
                  S.current.share_all_devices_hint_text,
                  style: AppFonts.subTitle(fontSize: AppSize.a10, color: AppColors.primaryText),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyleData _dropdownStyle() {
    return ButtonStyleData(
      height: AppSize.a50,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.a8),
      ),
    );
  }

  MenuItemStyleData _menuStyle() {
    return const MenuItemStyleData(
      height: AppSize.a48,
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this._qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _shareCodeTextController.text = scanData.code ?? "";
      });
    });
  }

  Widget _buildCheckBoxButtonLayout() {
    return Container(
      width: AppSize.a20,
      height: AppSize.a20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.a2),
        border: Border.all(color: AppColors.backgroundGrey, width: AppSize.a2),
      ),
      child: /*item.isSelected ?*/ const Icon(
        Icons.check,
        size: AppSize.a16,
        color: AppColors.orangee,
      ) /*: SizedBox(width: 1)*/,
    );
  }

  Future<void> _buildingSharingFunction() async {
    if (_shareCodeTextController.text.trim().isEmpty) {
      Common.showSnackBarMessage(context, S.current.you_need_to_enter_the_sharing_code_email_or_phone_number_of_the_shared_account, isError: true);
    } else {
      _toggleProcess(true);
      if (await Common.isConnectToServer()) {
        _shareManagerBloc.add(AddShareAccountEvent(uuid: _shareCodeTextController.text, type: _settingMemberType));
      } else {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
      }
    }
  }

  _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
