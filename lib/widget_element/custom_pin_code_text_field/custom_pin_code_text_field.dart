import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

typedef OnDone = void Function(String text);

class CustomPinCodeTextField extends StatefulWidget {
  final TextStyle? pinTextStyle;
  final double? pinBoxWidth;
  final double? pinBoxHeight;
  final bool? hideCharacter;
  final Function(String)? onDone;
  final Function(String)? onTextChanged;
  final bool? hasError;

  CustomPinCodeTextField({Key? key, this.pinTextStyle, this.pinBoxWidth,
    this.pinBoxHeight, this.hideCharacter, this.onDone, this.onTextChanged,
    this.hasError});

  @override
  State<CustomPinCodeTextField> createState() => _CustomPinCodeTextFieldState();
}

class _CustomPinCodeTextFieldState extends State<CustomPinCodeTextField> {

  TextEditingController controller = TextEditingController(text: "");

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
        wrapAlignment: WrapAlignment.center,
        controller: controller,
        maxLength: 6,
        pinBoxRadius: 5,
        pinBoxWidth: widget.pinBoxWidth ?? 40,
        pinBoxHeight: widget.pinBoxHeight ?? 50,
        pinBoxBorderWidth: 0.5,
        pinTextStyle: widget.pinTextStyle,
        highlightColor: Color(0xff010101),
        defaultBorderColor:Colors.grey,
        hasTextBorderColor:Colors.white,
        pinBoxColor: Colors.white,
        hasError: widget.hasError ?? false,
        onTextChanged: widget.onTextChanged,
        onDone: widget.onDone,
        hideCharacter : widget.hideCharacter?? false,

    );
  }
}
