import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/auth_controller.dart';
import 'package:pfe_app/views/forget_password/forget_password.dart';
import 'package:pfe_app/widget_common/applogo_widget.dart';
import 'package:pfe_app/widget_common/bg_widget.dart';
import 'package:pfe_app/widget_common/custom_textfield.dart';
import 'package:pfe_app/widget_common/our_button.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  //const PhoneScreen({super.key});
  final TextEditingController phoneController = TextEditingController();
  var controller = Get.put(AuthController());

  void phoneSignIn() {
    controller.phoneSignIn(context, phoneController.text);
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (context.screenHeight * 0.1).heightBox,
          applogoWidget(),
          10.heightBox,
          "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
          15.heightBox,
          Column(
            children: [
              customTextField(
                hint: 'Enter phone number',
                title: 'ddd',
                isPass: false,
                controller: phoneController,
              ),
              ourButton(onPress: phoneSignIn, title: 'Send OTP'),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Get.to(() => const ForgetPassword());
                    },
                    child: forgetPass.text.make()),
              ),
              5.heightBox,
              createNewAccount.text.color(fontGrey).make(),
            ],
          )
        ],
      )),
    ));
  }
}
