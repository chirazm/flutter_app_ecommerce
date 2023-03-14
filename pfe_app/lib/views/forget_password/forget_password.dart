import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/colors.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/consts/lists.dart';
import 'package:pfe_app/widget_common/bg_widget.dart';

import '../../../controllers/auth_controller.dart';
import '../../widget_common/applogo_widget.dart';
import '../../widget_common/custom_textfield.dart';
import '../../widget_common/our_button.dart';
import '../auth_screen/signup_screen.dart';
import '../home_screen/home.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<AuthController>();

    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
        children: [
          (context.screenHeight * 0.1).heightBox,
          applogoWidget(),
          10.heightBox,
          pleaseEnterEmail.text.fontFamily(bold).white.size(14).make(),
          25.heightBox,
          Obx(
            () => Column(
              children: [
                customTextField(
                    hint: emailForgot,
                    title: email,
                    isPass: false,
                    controller: controller.emailController),
                5.heightBox,
                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      )
                    : ourButton(
                        color: redColor,
                        title: "Send email",
                        textColor: whiteColor,
                        onPress: () async {
                          await controller.forgetPassword(
                              email: controller.emailController.text);
                        }).box.width(context.screenWidth - 50).make(),
              ],
            )
                .box
                .white
                .rounded
                .padding(const EdgeInsets.all(16))
                .width(context.screenWidth - 60)
                .shadowSm
                .make(),
          )
        ],
      )),
    ));
  }
}
