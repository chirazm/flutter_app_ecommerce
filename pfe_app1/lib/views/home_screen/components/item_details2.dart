import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/consts/lists.dart';
import 'package:pfe_app/controllers/product_controller.dart';
import 'package:pfe_app/models/product_model2.dart';
import 'package:pfe_app/views/cart_screen/cart_screen.dart';
import 'package:pfe_app/views/category_screen/seller.dart';
import 'package:pfe_app/views/chat_screen/chat_screen.dart';
import 'package:pfe_app/widget_common/our_button.dart';

class ItemDetails2 extends StatelessWidget {
  final Product2 product2;

  const ItemDetails2({
    Key? key,
    required this.product2,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    bool hasDiscount = product2.flashSalePrice != null;
    double oldPrice = double.parse(product2.oldPrice);
    double discountedPrice =
        hasDiscount ? double.parse(product2.flashSalePrice) : oldPrice;
    bool isFlashSaleExpired = hasDiscount &&
        product2.endDate != null &&
        DateTime.now().isAfter(product2.endDate!.toDate());

    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title:
              product2.name!.text.color(darkFontGrey).fontFamily(bold).make(),
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
                      controller.removeFromWishlist(product2.id, context);
                      controller.isFav(false);
                    } else {
                      controller.addToWishlist(product2.id, context);
                      controller.isFav(true);
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
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //swiper section
                      VxSwiper.builder(
                          autoPlay: true,
                          height: 310,
                          itemCount: product2.imageURL.length,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          itemBuilder: (context, index) {
                            //image
                            return Image.network(
                              product2.imageURL,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }),
                      10.heightBox,

                      //title and details section
                      product2.name!.text
                          .size(18)
                          .color(darkFontGrey)
                          .fontFamily(bold)
                          .make(),
                      10.heightBox,

                      10.heightBox,
                      if (isFlashSaleExpired)
                        Text(
                          '$oldPrice TND',
                          style: const TextStyle(
                            color: redColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      else if (hasDiscount && product2.endDate != null)
                        Row(
                          children: [
                            Text(
                              '$oldPrice TND',
                              style: const TextStyle(
                                color: darkFontGrey,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$discountedPrice TND',
                              style: const TextStyle(
                                color: redColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          '$oldPrice TND',
                          style: const TextStyle(
                            color: redColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                      //seller section
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Seller"
                                    .text
                                    .white
                                    .fontFamily(semibold)
                                    .size(16)
                                    .make(),
                                5.heightBox,
                                "${product2.seller}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .size(16)
                                    .make()
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.message_rounded,
                                color: darkFontGrey,
                              ),
                            ),
                          ),
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
                                              hasDiscount
                                                  ? discountedPrice
                                                  : oldPrice,
                                              discountedPrice,
                                              oldPrice,
                                              isFlashSaleExpired,
                                            );
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
                                              int.parse(product2.quantity));
                                          controller.calculateTotalPrice(
                                            hasDiscount
                                                ? discountedPrice
                                                : oldPrice,
                                            discountedPrice,
                                            oldPrice,
                                            isFlashSaleExpired,
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                      10.widthBox,
                                      "(${product2.quantity} available)"
                                          .text
                                          .color(fontGrey)
                                          .make(),
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
                      "${product2.desc}".text.color(Colors.black).make(),
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
                      vendorID: product2.vendorId,
                      imageURL: product2.imageURL[0],
                      title: product2.name,
                      sellername: product2.seller,
                      qty: controller.quantity.value,
                      tprice: controller.totalPrice.value,
                    );
                    VxToast.show(context, msg: "Added to cart");
                  } else {
                    VxToast.show(context, msg: "Minimum 1 product is required");
                  }
                },
                textColor: whiteColor,
                title: "Add To Cart",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
