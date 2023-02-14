import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/widget_common/applogo_widget.dart';
import 'package:pfe_app/widget_common/bg_widget.dart';
import 'package:pfe_app/widget_common/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      body: Center(
          child: Column(
        children: [
          (context.screenHeight * 0.1).heightBox,
          applogoWidget(),
          10.heightBox,
          "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
          10.heightBox,
          Column(
            children: [
              customTextField(hint: emailHint, title: email),
              customTextField(hint: passwordHint, title: password),
              TextButton(onPressed: () {}, child: forgetPass.text.make())
            ],
          )
              .box
              .white
              .rounded
              .padding(const EdgeInsets.all(16))
              .width(context.screenWidth)
              .make()
        ],
      )),
    ));
  }
}
