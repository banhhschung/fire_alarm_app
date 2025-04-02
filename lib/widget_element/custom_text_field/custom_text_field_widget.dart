import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatefulWidget {
  CustomTextFieldWidget({
    super.key,
    this.titleInput = "",
    this.isPassword = false,
    this.obscureText = true,
    this.controller,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.colorIcon,
    this.onTap,
    this.hintText = "",
    this.readOnly = false
  });
  final String titleInput;
  final bool isPassword;
  bool obscureText;
  final TextEditingController? controller;
  final FocusNode? nextFocusNode;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Color? colorIcon;
  final Function()? onTap;
  final String hintText;
  final bool readOnly;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.nextFocusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.nextFocusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          maxLines: 1,
          text: TextSpan(
            text: '',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            children: widget.titleInput.contains('*')
                ? [
              TextSpan(
                style: AppFonts.title(
                  fontSize: 14,
                  color: const Color(0xff858597),
                ),
                text: widget.titleInput
                    .substring(0, widget.titleInput.indexOf('*')),
              ),
              const TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.title
                ),
              ),
              TextSpan(
                text: widget.titleInput
                    .substring(widget.titleInput.indexOf('*') + 1),
                style: AppFonts.title(
                  fontSize: 14,
                  color: const Color(0xff858597),
                ),
              ),
            ]
                : [
              TextSpan(
                text: widget.titleInput,
                style: AppFonts.title(
                    fontSize: 14,
                    color: AppColors.title
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          readOnly: widget.readOnly,
          style: AppFonts.title(),
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          focusNode: _focusNode,
          controller: widget.controller,
          onFieldSubmitted: (value) {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }

            if (widget.onFieldSubmitted != null) {
              widget.onFieldSubmitted!(value);
            }
          },
          obscureText: widget.isPassword ? widget.obscureText : false,
          decoration: InputDecoration(
            hintStyle: AppFonts.hintText(),
            border: InputBorder.none,
            hintText: widget.hintText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.title),
            ),
            errorStyle: AppFonts.title(fontSize: 12,color: AppColors.title).copyWith(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1, color: Color(0xffB8B8D2)),
            ),
            suffixIcon: widget.isPassword
                ? Padding(
              padding: const EdgeInsets.only(
                right: 20,
                top: 16,
                bottom: 16,
              ),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  child: /*Image.asset(
                    !widget.obscureText
                        ? AppImages.iconEye
                        : AppImages.iconEyeClose,
                    width: 18,
                    height: 16,
                    fit: BoxFit.fitWidth,
                    color: widget.colorIcon ?? const Color(0xff1F1F39),
                  ),*/
                Icon(widget.obscureText ? Icons.visibility : Icons.visibility_off, size: AppSize.a24, color: AppColors.primaryText,)
              ),
            )
                : const SizedBox.shrink(),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 16,
            ),
            contentPadding: const EdgeInsets.only(
              left: 20,
              bottom: 15,
              top: 15,
            ),
          ),
        ),
      ],
    );
  }
}
