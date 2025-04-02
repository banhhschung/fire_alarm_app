import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class HighLightButton extends StatefulWidget {
  final VoidCallback onPress;
  final String title;
  final FocusNode? focusNode;
  final Color? buttonColor;
  final bool? preventMultiClick;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  HighLightButton(
      {required this.onPress,
      required this.title,
      this.focusNode,
      this.buttonColor,
      this.preventMultiClick = true,
      this.width = 390,
      this.height = 48,
      this.textStyle});

  @override
  State<StatefulWidget> createState() {
    return _HighLightButtonState();
  }
}

class _HighLightButtonState extends State<HighLightButton> {
  bool _isFirstPress = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widget.width,
      height: this.widget.height,
      decoration: BoxDecoration(
        color: widget.buttonColor ?? AppColors.orangee,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x33000000), offset: Offset(0, 2), blurRadius: 4, spreadRadius: 0)],
      ),
      child: TextButton(
          focusNode: widget.focusNode,
          child: Text(
            widget.title,
            style: widget.textStyle ?? AppFonts.title(
              color: AppColors.white
            ),
          ),
          onPressed: () {
            if (widget.preventMultiClick != null && widget.preventMultiClick!) {
              if (_isFirstPress) {
                widget.onPress();
                _isFirstPress = false;
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  _isFirstPress = true;
                });
              }
            } else {
              widget.onPress();
            }
          }),
    );
  }
}
