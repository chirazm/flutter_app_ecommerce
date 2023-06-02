import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/controllers/auth_controller.dart';
import 'package:marque_blanche_seller/views/home_screen/home.dart';
import 'package:marque_blanche_seller/views/widgets/our_button.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

import '../forget_password/forget_password.dart';
import '../widgets/loading_indicator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    var controller = Get.put(AuthController());
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: purpleColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.heightBox,
              normalText(text: welcome, size: 20.0),
              20.heightBox,
              Row(
                children: [
                  Image.asset(
                    icLogo,
                    width: 70,
                    height: 70,
                  )
                      .box
                      .border(color: white)
                      .rounded
                      .padding(const EdgeInsets.all(8))
                      .make(),
                  10.widthBox,
                  boldText(text: appname, size: 20.0)
                ],
              ),
              40.heightBox,
              normalText(text: loginTo, size: 18.0, color: lightGrey),
              10.heightBox,
              Obx(
                () => Column(
                  children: [
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: textfieldGrey,
                          prefixIcon: Icon(
                            Icons.email,
                            color: purpleColor,
                          ),
                          border: InputBorder.none,
                          hintText: emailHint),
                    ),
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: textfieldGrey,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: purpleColor,
                          ),
                          border: InputBorder.none,
                          hintText: passwordHint),
                    ),
                    10.heightBox,
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Get.to(() => const ForgetPassword());
                          },
                          child: normalText(
                              text: forgotPassword, color: purpleColor)),
                    ),
                    30.heightBox,
                    SizedBox(
                      width: context.screenWidth - 100,
                      child: controller.isloading.value
                          ? Center(
                              child: loadingIndicator(),
                            )
                          : ourButton(
                              title: login,
                              onPress: () async {
                                controller.isloading(true);
                                await controller.loginMethod(context: context);
                                controller.isloading(false);
                              },
                            ),
                    ),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .outerShadowMd
                    .padding(const EdgeInsets.all(8))
                    .make(),
              ),
              10.heightBox,
              Center(
                child: normalText(text: anyProblem, color: lightGrey),
              ),
              const Spacer(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
