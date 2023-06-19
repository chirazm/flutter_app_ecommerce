import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/controllers/profile_controller.dart';
import 'package:marque_blanche_seller/views/widgets/custom_textfield.dart';
import 'package:marque_blanche_seller/views/widgets/loading_indicator.dart';

import '../widgets/text_style.dart';

class ShopSettings extends StatefulWidget {
  const ShopSettings({Key? key}) : super(key: key);

  @override
  State<ShopSettings> createState() => _ShopSettingsState();
}

class _ShopSettingsState extends State<ShopSettings> {
  final ProfileController _controller = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller.fetchShopData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        title: boldText(text: shopSettings, size: 16.0),
        actions: [
          Obx(
            () => _controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _controller.isloading(true);
                        await _controller.updateShop(
                          shopname: _controller.shopNameController.text,
                          shopaddress: _controller.shopAddressController.text,
                          shopdesc: _controller.shopDescController.text,
                          shopmobile: _controller.shopMobileController.text,
                        );
                        VxToast.show(context, msg: "Shop updated");
                      }
                    },
                    child: normalText(text: save),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                customTextField(
                  label: ShopName,
                  hint: nameHint,
                  controller: _controller.shopNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop name';
                    }
                    return null;
                  },
                ),
                10.heightBox,
                customTextField(
                  label: address,
                  hint: shopAddressHint,
                  controller: _controller.shopAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop address';
                    }
                    return null;
                  },
                ),
                10.heightBox,
                customTextField(
                  label: mobile,
                  hint: shopMobileHint,
                  controller: _controller.shopMobileController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop mobile';
                    }
                    if (value.length != 8) {
                      return 'Please enter a valid mobile number (8 numbers)';
                    }
                    return null;
                  },
                ),
                10.heightBox,
                customTextField(
                  isDesc: true,
                  label: description,
                  hint: shopDescHint,
                  controller: _controller.shopDescController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
