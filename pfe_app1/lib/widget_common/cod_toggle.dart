import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/colors.dart';
import 'package:toggle_bar/toggle_bar.dart';

import '../controllers/cart_controller.dart';

class CodToggleSwitch extends StatelessWidget {
  const CodToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

    return Container(
      color: whiteColor,
      child: ToggleBar(
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.grey.shade600,
        selectedTabColor: Colors.green,
        labels: ['Pay online', "Cash on delivery"],
        onSelectionUpdated: (index) {
          controller.getPayementMethod(index);
        },
      ),
    );
  }
}
