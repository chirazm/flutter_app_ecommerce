import 'package:cloud_firestore/cloud_firestore.dart';
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
                        dashboardButton(
                          context,
                          title: orders,
                          count: getTotalOrders(currentUser.uid),
                          icon: icOrders,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    boldText(text: popular, color: Colors.black, size: 18.0),
                    const SizedBox(height: 20),
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        data.length,
                        (index) {
                          if (data[index]['p_wishlist'].length == 0) {
                            return const SizedBox();
                          } else {
                            return ListTile(
                              onTap: () {
                                Get.to(() => ProductDetails(
                                      data: data[index],
                                    ));
                              },
                              leading: Image.network(
                                data[index]['p_imgs'][0],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              title: boldText(
                                text: "${data[index]['p_name']}",
                                color: fontGrey,
                              ),
                              subtitle: normalText(
                                text: "${data[index]['p_price']} TND",
                                color: darkGrey,
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

  String getTotalOrders(String vendorUid) {
    int orderCount = 0;

    FirebaseFirestore.instance
        .collection('orders')
        .where('vendorUid', isEqualTo: vendorUid)
        .get()
        .then((QuerySnapshot snapshot) {
      orderCount = snapshot.size;
    }).catchError((error) {
      // Handle the error if any
      print('Error getting orders: $error');
    });

    return orderCount.toString();
  }
}
