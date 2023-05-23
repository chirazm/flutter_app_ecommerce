import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/cart_controller.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/views/cart_screen/CouponWidgett.dart';
import 'package:pfe_app/views/cart_screen/shipping_screen.dart';
import 'package:pfe_app/views/category_screen/item_details.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';
import '../../controllers/coupon_controller.dart';
import '../../widget_common/coupon_widget.dart';
import '../../widget_common/our_button.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  //CouponController couponController = Get.find<CouponController>();

  int deliveryFree = 7;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    bool cartIsEmpty = true;
    var payable = controller.totalP.value + deliveryFree;
    return Scaffold(
        backgroundColor: lightGrey,
        bottomNavigationBar: SizedBox(
          height: 50,
          child: ourButton(
            onPress: () {
              if (!cartIsEmpty) {
                Get.to(() => const ShippingDetails());
              }
            },
            color: cartIsEmpty ? redColor : fontGrey,
            textColor: whiteColor,
            title: "Proceed to shipping",
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   onPressed: () {
          //     Get.back();
          //   },
          //   icon: const Icon(Icons.arrow_back),
          // ),
          title: "Shopping cart"
              .text
              .color(darkFontGrey)
              .fontFamily(semibold)
              .make(),
        ),
        body: StreamBuilder(
          stream: FirestoreServices.getCart(currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              cartIsEmpty = true;

              return Center(
                child: "Cart is empty".text.color(darkFontGrey).make(),
              );
            } else {
              cartIsEmpty = false;
              var data = snapshot.data!.docs;
              controller.calculate(data);
              controller.productSnapshot = data;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: GestureDetector(
                              child: Image.network(
                                "${data[index]['img']}",
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: GestureDetector(
                              onTap: () {
                                Get.to(() => ItemDetails(
                                    title: "${data[index]['p_name']}",
                                    data: data[index]));
                              },
                              child:
                                  "${data[index]['title']} (x${data[index]['qty']})"
                                      .text
                                      .size(16)
                                      .fontFamily(semibold)
                                      .make(),
                            ),
                            subtitle: "${data[index]['tprice']}"
                                .numCurrency
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),
                            trailing: const Icon(
                              Icons.delete,
                              color: redColor,
                            ).onTap(() {
                              FirestoreServices.deleteDocument(data[index].id);
                            }),
                          );
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),

                    // i want in this part add couponwidget
                    //CouponWidgett(), // Add the CouponWidget here

                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: Border.all(color: redColor),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bill Details',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Basket value',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 70, 69, 69)),
                                      ),
                                    ),
                                    Text(
                                        "${controller.totalP.toStringAsFixed(3)} TND",
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 70, 69, 69))),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Delivery',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 70, 69, 69)),
                                      ),
                                    ),
                                    Text(
                                        "${deliveryFree.toStringAsFixed(3)} TND",
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 70, 69, 69))),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.green.shade200,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'Total Saving',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          "${payable.toStringAsFixed(3)} TND",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
