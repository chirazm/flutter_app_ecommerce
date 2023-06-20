import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/colors.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/services/store_services.dart';
import 'package:marque_blanche_seller/views/orders_screen/order_details.dart';

import '../widgets/loading_indicator.dart';

class OrderSearchScreen extends StatelessWidget {
  const OrderSearchScreen({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkGrey,
            )),
        title: Text(
          title!,
          style: TextStyle(color: darkGrey),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: StoreServices.searchOrdersByName(title!),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No buyer found."),
            );
          } else {
            var data = snapshot.data!.docs;
            var filtered = data
                .where(
                  (element) => element['order_by_name']
                      .toString()
                      .toLowerCase()
                      .startsWith(title!.toLowerCase()),
                )
                .toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (BuildContext context, int index) {
                  var order = filtered[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => OrderDetails(
                            title: order['order_by_name'],
                            data: order,
                          ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['order_by_name'].toString(),
                          style: TextStyle(color: darkGrey),
                        ),
                        SizedBox(height: 10),
                      ],
                    )
                        .box
                        .white
                        .margin(EdgeInsets.symmetric(horizontal: 4))
                        .outerShadowMd
                        .padding(const EdgeInsets.all(12))
                        .make(),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
