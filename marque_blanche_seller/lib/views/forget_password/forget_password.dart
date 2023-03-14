import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

import '../../controllers/auth_controller.dart';
import '../widgets/our_button.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: purpleColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              boldText(text: forgotPass, size: 30.0),
              20.heightBox,
              normalText(text: pleaseEnterEmail, size: 14.0),
              30.heightBox,
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
                    hintText: emailForgot),
              ),
              30.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: lightGrey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 17.0)),
                onPressed: () async {
                  await controller.forgetPassword(
                      email: controller.emailController.text);
                },
                child: const Text(
                  "Send email",
                  style: TextStyle(
                      color: purpleColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
