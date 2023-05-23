import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/cart_controller.dart';
import 'package:pfe_app/views/cart_screen/payment_method.dart';
import 'package:pfe_app/widget_common/custom_textfield.dart';
import 'package:pfe_app/widget_common/our_button.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (controller.addressController.text.isEmpty ||
                controller.cityController.text.isEmpty ||
                controller.stateController.text.isEmpty ||
                controller.phoneController.text.isEmpty ||
                controller.postalcodeController.text.isEmpty ||
                controller.addressController.text.length < 10 ||
                controller.phoneController.text.length != 8 ||
                controller.postalcodeController.text.length != 4) {
              String errorMessage = '';
              if (controller.addressController.text.isEmpty) {
                errorMessage += 'Address must not be empty. ';
              }
              if (controller.cityController.text.isEmpty) {
                errorMessage += 'City must not be empty. ';
              }
              if (controller.stateController.text.isEmpty) {
                errorMessage += 'State must not be empty. ';
              }
              if (controller.phoneController.text.isEmpty) {
                errorMessage += 'Phone must not be empty. ';
              } else if (controller.phoneController.text.length != 8) {
                errorMessage += 'Phone number must be 8 digits. ';
              }
              if (controller.postalcodeController.text.isEmpty) {
                errorMessage += 'Postal Code must not be empty. ';
              } else if (controller.postalcodeController.text.length != 4) {
                errorMessage += 'Postal Code must be 4 digits. ';
              }
              VxToast.show(context, msg: errorMessage);
            } else {
              Get.to(() => const PaymentMethods());
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            customTextField(
              hint: "Address",
              isPass: false,
              title: "Address",
              controller: controller.addressController,
              validator: (value) {},
            ),
            customTextField(
              hint: "City",
              isPass: false,
              title: "City",
              controller: controller.cityController,
              validator: (value) {},
            ),
            customTextField(
                hint: "State",
                isPass: false,
                title: "State",
                controller: controller.stateController,
                validator: (value) {}),
            customTextField(
                hint: "Postal Code",
                isPass: false,
                title: "Postal Code",
                controller: controller.postalcodeController,
                validator: (value) {}),
            customTextField(
                hint: "Phone",
                isPass: false,
                title: "Phone",
                controller: controller.phoneController,
                validator: (value) {}),
          ],
        ),
      ),
    );
  }
}
