import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/home_controller.dart';
import 'package:pfe_app/models/product_model.dart';

import 'package:get/get.dart';
import 'package:pfe_app/views/category_screen/item_details.dart';
import 'package:pfe_app/views/home_screen/components/count_down_Timer.dart';
import 'package:pfe_app/views/home_screen/components/item_details2.dart';
import 'package:pfe_app/widget_common/our_button.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model2.dart';

class FlashSaleScreen extends StatefulWidget {
  const FlashSaleScreen({Key? key}) : super(key: key);

  @override
  _FlashSaleScreenState createState() => _FlashSaleScreenState();
}

class _FlashSaleScreenState extends State<FlashSaleScreen> {
  @override
  void initState() {
    super.initState();
    controller.resetQuantity();
  }

  var controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: redColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
        title: "Flash Sale".text.color(whiteColor).fontFamily(semibold).make(),
      ),
      body: Container(
        color: whiteColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('endDate', isNull: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<Product> products = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return Product(
                  id: doc.id,
                  name: data['p_name'],
                  imageURL: data['p_imgs'][0],
                  endDate: data['endDate'] != null
                      ? (data['endDate'] as Timestamp).toDate()
                      : null,
                  oldPrice: data['p_price'].toString(),
                  flashSalePrice: data['discountedPrice'].toString(),
                  seller: data['p_seller'],
                  vendorId: data['vendor_id'],
                  quantity: num.parse(data['p_quantity']),
                );
              }).toList();

              List<Product> activeProducts = products.where((product) {
                DateTime now = DateTime.now();
                Duration remainingTime = product.endDate!.difference(now);
                return remainingTime.inDays >= -2;
              }).toList();

              if (activeProducts.isEmpty) {
                return const Center(
                  child: Text(
                    'No offers yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: activeProducts.length,
                itemBuilder: (context, index) {
                  Product product = activeProducts[index];
                  DateTime now = DateTime.now();
                  Duration remainingTime = product.endDate!.difference(now);
                  bool offerExpired =
                      remainingTime.isNegative || remainingTime.inSeconds == 0;

                  return GestureDetector(
                    onTap: () {
                      // Get.to(() => ItemDetails(
                      //       title: product.name,
                      //       data: product,
                      //     ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: lightGolden2,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                product.imageURL,
                                height: 240,
                                width: 320,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ' ${product.oldPrice} TND',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                ' ${product.flashSalePrice} TND',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: redColor,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();

                                            controller.calculateTotalPrice(
                                              double.parse(
                                                  product.flashSalePrice),
                                              double.parse(
                                                  product.flashSalePrice),
                                              double.parse(product.oldPrice),
                                              offerExpired,
                                            );
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                        controller.quantity.value.text
                                            .size(16)
                                            .color(darkFontGrey)
                                            .fontFamily(bold)
                                            .make(),
                                        IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                                product.quantity);

                                            controller.calculateTotalPrice(
                                              double.parse(
                                                  product.flashSalePrice),
                                              double.parse(
                                                  product.flashSalePrice),
                                              double.parse(product.oldPrice),
                                              offerExpired,
                                            );
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ).box.make(),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_shopping_cart_outlined,
                                  color: darkFontGrey,
                                ),
                                onPressed: () {
                                  if (controller.quantity.value > 0) {
                                    controller.addToCart(
                                      context: context,
                                      vendorID: product.vendorId,
                                      imageURL: product.imageURL,
                                      title: product.name,
                                      sellername: product.seller,
                                      qty: controller.quantity.value,
                                      tprice: controller.totalPrice.value,
                                    );
                                    VxToast.show(context, msg: "Added to cart");
                                  } else {
                                    VxToast.show(context,
                                        msg: "Minimum 1 product is required");
                                  }
                                },
                              ),
                            ],
                          ),
                          offerExpired
                              ? Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.grey,
                                  child: const Text(
                                    'Offer expired',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : CountdownTimer(
                                  duration: remainingTime,
                                ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
