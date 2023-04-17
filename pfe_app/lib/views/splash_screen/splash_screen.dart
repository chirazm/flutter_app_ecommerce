import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/colors.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/views/auth_screen/login_screen.dart';
import 'package:pfe_app/views/home_screen/home.dart';
import 'package:pfe_app/views/onboarding_screen/on_boarding_screen.dart';
import 'package:pfe_app/widget_common/applogo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //Get.to(() => const LoginScreen());

      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.to(() => const OnBoardingScreen());
        } else {
          Get.to(() => const Home());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                icSplashBg,
                width: 300,
              ),
            ),
            20.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            30.widthBox,
            const Spacer(),
            RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "Be at the heart  \n",
                        style: TextStyle(
                          fontFamily: semibold,
                          color: whiteColor,
                          fontSize: 30,
                        )),
                    TextSpan(
                        text: "of your store",
                        style: TextStyle(
                            fontFamily: semibold,
                            color: whiteColor,
                            fontSize: 30)),
                  ],
                )),

            //credits.text.white.fontFamily(semibold).size(25).make(),
            30.heightBox,
          ],
        ),
      ),
    );
  }
}
