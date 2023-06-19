import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/controllers/products_controller.dart';
import 'package:marque_blanche_seller/views/products_screen/components/product_dropdown.dart';
import 'package:marque_blanche_seller/views/products_screen/components/product_images.dart';
import 'package:marque_blanche_seller/views/widgets/custom_textfield.dart';
import 'package:marque_blanche_seller/views/widgets/loading_indicator.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    var controller = Get.find<ProductsController>();
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: white,
            ),
          ),
          title: boldText(text: "Add product", size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator()
                : TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        controller.isloading(true);
                        await controller.uploadImages();
                        await controller.uploadProduct(context);

                        // Show snackbar message when the product is added
                        Get.snackbar(
                          "Product Added",
                          "The product has been added successfully",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );

                        controller.pnameController.clear();
                        controller.pdescController.clear();
                        controller.ppriceController.clear();
                        controller.pquantityController.clear();
                        controller.pImagesList.assignAll(List.filled(3, null));

                        Get.back();
                      }
                    },
                    child: boldText(text: save, color: white),
                  ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextField(
                    hint: "eg. Shoes",
                    label: "Product name",
                    controller: controller.pnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  10.heightBox,
                  customTextField(
                    hint: "eg. Nice product",
                    label: "Description",
                    isDesc: true,
                    controller: controller.pdescController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  10.heightBox,
                  customTextField(
                    hint: "eg. 100TND",
                    label: "Price",
                    controller: controller.ppriceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price';
                      }
                      return null;
                    },
                  ),
                  10.heightBox,
                  customTextField(
                    hint: "eg. 20",
                    label: "Quantity",
                    controller: controller.pquantityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      return null;
                    },
                  ),
                  10.heightBox,
                  productDropdown(
                    "Category",
                    controller.categoryList,
                    controller.categoryvalue,
                    controller,
                  ),
                  10.heightBox,
                  productDropdown(
                    "Subcategory",
                    controller.subcategoryList,
                    controller.subcategoryvalue,
                    controller,
                  ),
                  10.heightBox,
                  const Divider(
                    color: white,
                  ),
                  boldText(text: "Choose product images"),
                  10.heightBox,
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) => controller.pImagesList[index] != null
                            ? Image.file(
                                controller.pImagesList[index],
                                width: 100,
                              ).onTap(() {
                                controller.pickImage(index, context);
                              })
                            : productImages(label: "${index + 1}").onTap(() {
                                controller.pickImage(index, context);
                              }),
                      ),
                    ),
                  ),
                  5.heightBox,
                  normalText(
                    text: "First image will be your display image",
                    color: lightGrey,
                  ),
                  const Divider(
                    color: white,
                  ),
                  10.heightBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
