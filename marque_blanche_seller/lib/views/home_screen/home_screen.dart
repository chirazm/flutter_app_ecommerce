import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/services/store_services.dart';
import 'package:marque_blanche_seller/views/products_screen/product_details.dart';
import 'package:marque_blanche_seller/views/widgets/appbar_widget.dart';
import 'package:marque_blanche_seller/views/widgets/dashboard_button.dart';
import 'package:marque_blanche_seller/views/widgets/loading_indicator.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

import '../../const/const.dart';
import 'package:intl/intl.dart' as intl;

import '../../controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var currentUser = Get.find<AuthController>().user;
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;

            data.sort((a, b) =>
                b['p_wishlist'].length.compareTo(a['p_wishlist'].length));

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        dashboardButton(
                          context,
                          title: products,
                          count: "${data.length}",
                          icon: icProducts,
                        ),
                        FutureBuilder<int>(
                          future: getTotalOrders(currentUserId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error');
                            } else {
                              int orderCount = snapshot.data ?? 0;
                              return dashboardButton(
                                context,
                                title: orders,
                                count: orderCount.toString(),
                                icon: icOrders,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    boldText(
                      text: popular,
                      color: Colors.black,
                      size: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 20),
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        data.length,
                        (index) {
                          bool hasDiscount =
                              data[index]['discountedPrice'] != null;
                          double oldPrice =
                              double.parse(data[index]['p_price']);
                          double discountedPrice = hasDiscount
                              ? double.parse(data[index]['discountedPrice'])
                              : oldPrice;
                          bool isFlashSaleExpired = hasDiscount &&
                              data[index]['endDate'] != null &&
                              DateTime.now()
                                  .isAfter(data[index]['endDate'].toDate());
                          if (data[index]['p_wishlist'].length == 0) {
                            return const SizedBox();
                          } else {
                            return ListTile(
                              onTap: () {
                                Get.to(() => ProductDetails(
                                      data: data[index],
                                    ));
                              },
                              leading: Container(
                                height: 70,
                                width: 70,
                                child: Image.network(
                                  data[index]['p_imgs'][0],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: boldText(
                                text: "${data[index]['p_name']}",
                                color: fontGrey,
                                fontWeight: FontWeight.bold,
                              ),
                              subtitle: Row(
                                children: [
                                  if (isFlashSaleExpired)
                                    Text(
                                      '$oldPrice TND',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    )
                                  else if (hasDiscount &&
                                      data[index]['endDate'] != null)
                                    Row(
                                      children: [
                                        Text(
                                          '$oldPrice TND',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '$discountedPrice TND',
                                          style: const TextStyle(
                                            color: green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      '$oldPrice TND',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<int> getTotalOrders(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection(ordersCollection).get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          snapshot.docs;

      int orderCount = 0;

      for (var doc in documents) {
        List<dynamic> vendors = doc.data()['vendors'];
        if (vendors.contains(uid)) {
          orderCount++;
        }
      }

      return orderCount;
    } catch (error) {
      print('Error getting orders: $error');
      return 0;
    }
  }
}
