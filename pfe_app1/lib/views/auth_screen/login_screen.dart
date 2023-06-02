import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/auth_controller.dart';
import 'package:pfe_app/views/auth_screen/signup_screen.dart';
import 'package:pfe_app/views/forget_password/forget_password.dart';
import 'package:pfe_app/views/home_screen/home.dart';
import 'package:pfe_app/widget_common/applogo_widget.dart';
import 'package:pfe_app/widget_common/bg_widget.dart';
import 'package:pfe_app/widget_common/custom_textfield.dart';
import 'package:pfe_app/widget_common/our_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  //static const String id = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
        children: [
          (context.screenHeight * 0.1).heightBox,
          applogoWidget(),
          10.heightBox,
          "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
          15.heightBox,
          Obx(
            () => Column(
              children: [
                customTextField(
                    hint: emailHint,
                    title: email,
                    isPass: false,
                    controller: controller.emailController,
                    ),
                customTextField(
                    hint: passwordHint,
                    title: password,
                    isPass: true,
                    controller: controller.passwordController,
                    ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Get.to(() => const ForgetPassword());
                      },
                      child: forgetPass.text.color(darkFontGrey).make()),
                ),
                5.heightBox,
                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      )
                    : ourButton(
                        color: redColor,
                        title: login,
                        textColor: whiteColor,
                        onPress: () async {
                          controller.isloading(true);
                          await controller
                              .loginMethod(context: context)
                              .then((value) {
                            if (value != null) {
                              VxToast.show(context, msg: loggedin);
                              Get.offAll(() => const Home());
                            } else {
                              controller.isloading(false);
                            }
                          });
                        }).box.width(context.screenWidth - 50).make(),
                5.heightBox,
                createNewAccount.text.color(fontGrey).make(),
                5.heightBox,
                ourButton(
                    color: lightGolden,
                    title: signup,
                    textColor: redColor,
                    onPress: () {
                      Get.to(() => const SignUpScreen());
                    }).box.width(context.screenWidth - 50).make(),
                10.heightBox,
                //loginWith.text.color(fontGrey).make(),
                5.heightBox,
                // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //   ElevatedButton(
                //     onPressed: () {
                //       controller.signInWithGoogle(context);
                //     },
                //     child: const Icon(Icons.face),
                //   )
                // ])
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
