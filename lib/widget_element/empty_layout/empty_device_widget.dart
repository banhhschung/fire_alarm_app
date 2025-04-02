
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:flutter/material.dart';

class EmptyDeviceWidget extends StatelessWidget{
  final String? title;
  final String? titleButton;
  final VoidCallback? onPress;
  final bool showButtonPress;

  const EmptyDeviceWidget({super.key, this.title, this.titleButton, this.onPress, this.showButtonPress = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: SizedBox(width: AppSize.a100, height: AppSize.a100, child: Assets.images.devicesEmptyImg.image())),
        Text(title ?? S.current.do_not_have_device, style: AppFonts.titleHeaderBold(color: AppColors.secondaryText),),
        const SizedBox(height: AppSize.a30,),
        if(showButtonPress) Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p116),
          child: HighLightButton(
            textStyle: AppFonts.buttonText(color: AppColors.white),
            title: titleButton ?? S.current.add_device,
            onPress: onPress!,
          ),
        ),
      ],
    );
  }
}