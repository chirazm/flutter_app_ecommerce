import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/cart_controller.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/views/cart_screen/shipping_screen.dart';
import 'package:pfe_app/views/category_screen/item_details.dart';
import 'package:pfe_app/widget_common/cod_toggle.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';

import '../../widget_common/coupon_widget.dart';
import '../../widget_common/our_button.dart';

class CartScreen extends StatelessWidget {
  //late final DocumentSnapshot document;
  //int discount = 30;

  int deliveryFree = 7;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

    var payable = controller.totalP.value + deliveryFree;
    return Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 50,
          child: ourButton(
            color: redColor,
            onPress: () {
              Get.to(() => const ShippingDetails());
            },
            textColor: whiteColor,
            title: "Proceed to shipping",
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
              return Center(
                child: "Cart is empty".text.color(darkFontGrey).make(),
              );
            } else {
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
                                  FirestoreServices.deleteDocument(
                                      data[index].id);
                                }),
                              );
                            })),

                    const Divider(
                      color: Colors.grey,
                    ),
                    // SizedBox(
                    // // child: CouponWidget((doc.data() as dynamic)['uid']),

                    // ),
                    // SizedBox(
                    //   width: 1000,
                    //   child: Wrap(
                    //     direction: Axis.horizontal,
                    //     children: snapshot.data!.docs
                    //         .map((DocumentSnapshot document) {
                    //       return CouponWidget(
                    //           (document.data() as dynamic)['uid']);
                    //     }).toList(),
                    //   ),
                    // ),
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
                                // Row(
                                //   children: [
                                //     const Expanded(
                                //       child: Text(
                                //         'Discount',
                                //         style: TextStyle(color: Colors.grey),
                                //       ),
                                //     ),
                                //     Text("$discount TND",
                                //         style: const TextStyle(
                                //             color: Colors.grey)),
                                //   ],
                                // ),
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
                                // Row(
                                //   children: [
                                //     const Expanded(
                                //       child: Text(
                                //         'Total amount payable',
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     ),
                                //     Text(
                                //       "${payable.toStringAsFixed(0)} TND",
                                //       style: const TextStyle(
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //   ],
                                // ),
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

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     "Total Price"
                    //         .text
                    //         .fontFamily(semibold)
                    //         .color(darkFontGrey)
                    //         .make(),
                    //     Obx(
                    //       () => "${controller.totalP.value}"
                    //           .numCurrency
                    //           .text
                    //           .fontFamily(semibold)
                    //           .color(darkFontGrey)
                    //           .make(),
                    //     )
                    //   ],
                    // )
                    //     .box
                    //     .padding(const EdgeInsets.all(12))
                    //     .color(lightGolden)
                    //     .width(context.screenWidth - 60)
                    //     .roundedSM
                    //     .make(),

                    // SizedBox(
                    //   width: context.screenWidth - 60,
                    //   child: ourButton(
                    //     color: redColor,
                    //     onPress: () {},
                    //     textColor: whiteColor,
                    //     title: "Proceed to shipping",
                    //   ),
                    // )
                  ],
                ),
              );
            }
          },
        ));
  }
}
