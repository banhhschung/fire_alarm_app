import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: _loginContentWidget()),
    );
  }

  Widget _loginContentWidget() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Assets.images.backgroundLogin.image(),
            Text("Đăng nhập", style: AppFonts.titleBold(
                24,
            ),)
          ],
        ),
        CustomTextFieldWidget(
          titleInput: 'Số điện thoại / Email',
          hintText: "Nhập số điện thoại hoặc email",
        ),
        CustomTextFieldWidget(
          titleInput: 'Mật khẩu',
          hintText: "Nhập mật khẩu",
          isPassword: true,
        ),
      ],
    );
  }
}
