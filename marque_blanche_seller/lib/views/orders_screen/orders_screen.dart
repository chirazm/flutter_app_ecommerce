import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:marque_blanche_seller/controllers/orders_controller.dart';
import 'package:marque_blanche_seller/services/store_services.dart';
import 'package:marque_blanche_seller/views/orders_screen/order_details.dart';
import 'package:marque_blanche_seller/views/orders_screen/order_search_screen.dart';
import 'package:marque_blanche_seller/views/widgets/appbar_widget.dart';
import 'package:marque_blanche_seller/views/widgets/loading_indicator.dart';

import '../../const/const.dart';
import '../widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedIndex = 0;
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
    var controller = Get.put(OrdersController());
    var currentUser = FirebaseAuth.instance.currentUser;
    var currentVendorId = currentUser?.uid;
    return Scaffold(
      appBar: appbarWidget(orders),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('vendors', arrayContains: currentVendorId)
              .where('order_confirmed', isEqualTo: confirmed)
              .where('order_delivered', isEqualTo: delivered)
              .where('order_on_delivery', isEqualTo: onDelivery)
              .where('order_placed', isEqualTo: pending)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else {
              var data = snapshot.data!.docs;
              return SafeArea(
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      alignment: Alignment.center,
                      color: lightGrey,
                      child: TextFormField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: const Icon(Icons.search).onTap(() {
                            if (controller
                                .searchController.text.isNotEmptyAndNotNull) {
                              Get.to(() => OrderSearchScreen(
                                    title: controller.searchController.text,
                                  ));
                            }
                          }),
                          filled: true,
                          fillColor: white,
                          hintText: "Search anything",
                          hintStyle: const TextStyle(color: textfieldGrey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ChipsChoice<int>.single(
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              value: _selectedIndex,
                              onChanged: (val) {
                                setState(() {
                                  _selectedIndex = val;
                                  filter(val);
                                });
                              },
                              choiceItems: C2Choice.listFrom<int, String>(
                                source: options,
                                value: (i, v) => i,
                                label: (i, v) => v,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: List.generate(data.length, (index) {
                                var time = data[index]['order_date'].toDate();
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    onTap: () {
                                      Get.to(() => OrderDetails(
                                            data: data[index],
                                          ));
                                    },
                                    tileColor: textfieldGrey,
                                    title: Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: darkGrey,
                                        ),
                                        10.widthBox,
                                        boldText(
                                          text:
                                              "${data[index]['order_by_name']}",
                                          color: purpleColor,
                                          FontWeight: FontWeight.bold,
                                          size: 17.0,
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                color: darkGrey,
                                              ),
                                              10.widthBox,
                                              boldText(
                                                text: intl.DateFormat()
                                                    .add_yMEd()
                                                    .format(time),
                                                color: fontGrey,
                                                FontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.payment,
                                                  color: darkGrey,
                                                ),
                                                10.widthBox,
                                                boldText(
                                                  text:
                                                      " ${data[index]['payment_method']}",
                                                  color: red,
                                                  FontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: boldText(
                                      text:
                                          " ${data[index]['total_amount']} TND",
                                      color: purpleColor,
                                      size: 20.0,
                                    ),
                                  )
                                      .box
                                      .margin(const EdgeInsets.only(bottom: 4))
                                      .make(),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
