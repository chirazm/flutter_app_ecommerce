import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/controllers/products_controller.dart';
import 'package:marque_blanche_seller/views/products_screen/components/product_dropdown.dart';
import 'package:marque_blanche_seller/views/products_screen/components/product_images.dart';
import 'package:marque_blanche_seller/views/widgets/custom_textfield.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkGrey,
            )),
        title: boldText(text: "Add product", size: 16.0),
        actions: [
          TextButton(
              onPressed: () {}, child: boldText(text: save, color: purpleColor))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextField(
                  hint: "eg. Shoes",
                  label: "Product name",
                  controller: controller.pnameController),
              10.heightBox,
              customTextField(
                  hint: "eg. Nice product",
                  label: "Description",
                  isDesc: true,
                  controller: controller.pdescController),
              10.heightBox,
              customTextField(
                  hint: "eg. 100TND",
                  label: "Price",
                  controller: controller.ppriceController),
              10.heightBox,
              customTextField(
                  hint: "eg. 20",
                  label: "Quantity",
                  controller: controller.pquantityController),
              10.heightBox,
              productDropdown("Category", controller.categoryList,
                  controller.categoryvalue, controller),
              10.heightBox,
              productDropdown("Subcategory", controller.subcategoryList,
                  controller.subcategoryvalue, controller),
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
                            })),
                ),
              ),
              5.heightBox,
              normalText(
                  text: "First image will be your display image",
                  color: lightGrey),
              const Divider(
                color: white,
              ),
              10.heightBox,
              boldText(text: "Choose product colors"),
              10.heightBox,
              Obx(
                () => Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                      9,
                      (index) => Stack(alignment: Alignment.center, children: [
                            VxBox()
                                .color(Vx.randomPrimaryColor)
                                .roundedFull
                                .size(50, 50)
                                .make()
                                .onTap(() {
                              controller.selectedColorIndex.value = index;
                            }),
                            controller.selectedColorIndex.value == index
                                ? const Icon(
                                    Icons.done,
                                    color: white,
                                  )
                                : const SizedBox()
                          ])),
                ),
              ),
              100.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
