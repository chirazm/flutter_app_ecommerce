import 'package:cloud_firestore/cloud_firestore.dart';
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

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(OrdersController());
    return Scaffold(
      appBar: appbarWidget(orders),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: StoreServices.getOrders(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      20.heightBox,
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
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
                                            size: 17.0),
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
                                                  FontWeight: FontWeight.w500),
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
                                                    FontWeight:
                                                        FontWeight.w500),
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
                                        size: 20.0),
                                  )
                                      .box
                                      .margin(const EdgeInsets.only(bottom: 4))
                                      .make(),
                                );
                              }),
                            ),
                          )),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
