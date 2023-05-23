import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/models/product_model.dart';
import 'package:pfe_app/views/cart_screen/cart_screen.dart';
import 'package:pfe_app/views/chat_screen/chat_screen.dart';
import 'package:pfe_app/widget_common/our_button.dart';

import '../../../controllers/product_controller.dart';

class ItemDetails2 extends StatelessWidget {
  final Product data;
  final String? title;

  ItemDetails2({
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Get.to(() => CartScreen());
              },
            ),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeFromWishlist(data.id, context);
                      //controller.isFav(false);
                    } else {
                      controller.addToWishlist(data.id, context);
                      //controller.isFav(true);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: controller.isFav.value ? redColor : fontGrey,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VxSwiper.builder(
                          autoPlay: true,
                          height: 310,
                          itemCount: data.imageURL.length,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          itemBuilder: (context, index) {
                            //image
                            return Image.network(
                              data.imageURL,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }),

                      //title and details section
                      10.heightBox,
                      Text(
                        ' ${data.name} ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: darkFontGrey),
                      ),

                      //price
                      10.heightBox,
                      Text(
                        '${data.price}'.numCurrency,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: redColor),
                      ),
                      10.heightBox,

                      //seller section
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Seller",
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontFamily: semibold),
                                ),
                                5.heightBox,
                                Text(
                                  '${data.seller}',
                                  style: const TextStyle(
                                      color: darkFontGrey,
                                      fontFamily: semibold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.message_rounded,
                              color: darkFontGrey,
                            ),
                          ).onTap(() {
                            Get.to(
                              () => const ChatScreen(),
                              arguments: [data.seller, data.vendorId],
                            );
                          }),
                        ],
                      )
                          .box
                          .height(60)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .color(textfieldGrey)
                          .make(),

                      //other section
                      Obx(
                        () => Column(
                          children: [
                            //quantity row
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Quantity : "
                                      .text
                                      .color(textfieldGrey)
                                      .color(Colors.black)
                                      .fontWeight(FontWeight.bold)
                                      .size(14)
                                      .make(),
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPrice(
                                                int.parse(data.price));
                                          },
                                          icon: const Icon(Icons.remove)),
                                      controller.quantity.value.text
                                          .size(16)
                                          .color(darkFontGrey)
                                          .fontFamily(bold)
                                          .make(),
                                      IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                                int.parse(data.quantity));
                                            controller.calculateTotalPrice(
                                                int.parse(data.price));
                                          },
                                          icon: const Icon(Icons.add)),
                                      10.widthBox,
                                      Text(
                                        "(${data.quantity} available)",
                                        style: const TextStyle(color: fontGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),

                            //total row
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Total : "
                                      .text
                                      .color(Colors.black)
                                      .fontWeight(FontWeight.bold)
                                      .size(14)
                                      .make(),
                                ),
                                "${controller.totalPrice.value}"
                                    .numCurrency
                                    .text
                                    .color(redColor)
                                    .size(16)
                                    .fontFamily(bold)
                                    .make(),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                          ],
                        ).box.white.shadowSm.make(),
                      ),

                      //description section
                      10.heightBox,
                      "Description : "
                          .text
                          .color(Colors.black)
                          .fontWeight(FontWeight.bold)
                          .size(14)
                          .make(),
                      10.heightBox,
                      Text(
                        'Description: ${data.desc}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      10.heightBox,
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: redColor,
                onPress: () {
                  if (controller.quantity.value > 0) {
                    controller.addToCart(
                      //color: data['p_colors'][controller.colorIndex.value],
                      context: context,
                      vendorID: data.vendorId,
                      imageURL: data.imageURL,
                      title: data.name,
                      sellername: data.seller,
                      qty: controller.quantity.value,
                      tprice: controller.totalPrice.value,
                    );
                    VxToast.show(context, msg: "Added to cart");
                  } else {
                    VxToast.show(context, msg: "Minimum 1 product is required");
                  }
                },
                textColor: whiteColor,
                title: "Add to cart",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
