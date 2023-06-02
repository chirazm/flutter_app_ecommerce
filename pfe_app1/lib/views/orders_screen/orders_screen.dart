import 'package:chips_choice/chips_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/order_controller.dart';
import 'package:pfe_app/views/orders_screen/orders_details.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int? _selectedIndex;
  int tag = 0;
  List<String> options = [
    'All Orders',
    'Pending',
    'Confirmed',
    'On Delivery',
    'Delivered',
  ];
  bool? pending;
  bool? confirmed;
  bool? onDelivery;
  bool? delivered;
  filter(val) {
    if (val == 1) {
      setState(() {
        confirmed = false;
        onDelivery = false;
        delivered = false;
      });
    }
    if (val == 2) {
      setState(() {
        confirmed = true;
        onDelivery = false;
        delivered = false;
      });
    }
    if (val == 3) {
      setState(() {
        onDelivery = true;
        delivered = false;
      });
    }

    if (val == 4) {
      setState(() {
        confirmed = true;
        onDelivery = true;
        delivered = true;
      });
    }
    if (val == 0) {
      setState(() {
        confirmed = null;
        onDelivery = null;
        delivered = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(OrderController());
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: orders
            .where('order_by', isEqualTo: userId)
            .where('order_confirmed', isEqualTo: confirmed)
            .where('order_delivered', isEqualTo: delivered)
            .where('order_on_delivery', isEqualTo: onDelivery)
            .where('order_placed', isEqualTo: pending)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 241, 230, 230),
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  child: ChipsChoice<int>.single(
                    choiceStyle: C2ChipStyle.filled(
                      foregroundSpacing: 20,
                      borderWidth: 20,
                      color: const Color.fromARGB(255, 160, 160, 160),
                      borderRadius: BorderRadius.circular(25),
                      foregroundStyle: const TextStyle(fontSize: 16),
                      selectedStyle: const C2ChipStyle(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        backgroundColor: Colors.green,
                        foregroundStyle: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    choiceCheckmark: true,
                    value: tag,
                    onChanged: (val) {
                      setState(() {
                        tag = val;
                      });
                      filter(tag);
                    },
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: options,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected = _selectedIndex ==
                          index; // assuming _selectedIndex holds the index of the selected ListTile

                      return ExpansionTile(
                        title: Row(
                          children: [
                            "${index + 1}"
                                .text
                                .fontFamily(bold)
                                .color(darkFontGrey)
                                .xl
                                .make(),
                            const SizedBox(width: 20),
                            'Ordered'
                                .toString()
                                .text
                                .color(redColor)
                                .size(17)
                                .fontFamily(bold)
                                .make(),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const SizedBox(width: 29),
                            'On ${DateFormat.yMMMd().format(data[index]['order_date'].toDate())}'
                                .text
                                .color(isSelected ? golden : fontGrey)
                                .make(),
                          ],
                        ),
                        trailing: '${data[index]['total_amount']} TND'
                            .text
                            .fontFamily(bold)
                            .color(isSelected ? golden : fontGrey)
                            .make(),
                        children: [
                          ListTile(
                            horizontalTitleGap: 0,
                            title: "Order Details"
                                .text
                                .fontFamily(bold)
                                .color(darkFontGrey)
                                .xl
                                .make(),
                            subtitle: 'View order details'.text.make(),
                            trailing: IconButton(
                              onPressed: () {
                                Get.to(() => OrderDetails(
                                      data: data[index],
                                    ));
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: darkFontGrey,
                              ),
                            ),
                          ),
                        ],
                        onExpansionChanged: (expanded) {
                          if (expanded) {
                            setState(() {
                              _selectedIndex =
                                  index; // update selected index when ExpansionTile is expanded
                            });
                          } else {
                            setState(() {
                              _selectedIndex =
                                  null; // reset selected index when ExpansionTile is collapsed
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
