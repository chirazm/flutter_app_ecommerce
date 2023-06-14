import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          title: "My Wishlist"
              .text
              .color(darkFontGrey)
              .fontFamily(semibold)
              .make()),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No wishlist yet !".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool hasDiscount =
                            data[index]['discountedPrice'] != null;
                        double oldPrice = double.parse(data[index]['p_price']);
                        double discountedPrice = hasDiscount
                            ? double.parse(data[index]['discountedPrice'])
                            : oldPrice;
                        bool isFlashSaleExpired = hasDiscount &&
                            data[index]['endDate'] != null &&
                            DateTime.now()
                                .isAfter(data[index]['endDate'].toDate());
                        return ListTile(
                          leading: Image.network(
                            "${data[index]['p_imgs'][0]}",
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          title: "${data[index]['p_name']}"
                              .text
                              .size(16)
                              .fontFamily(semibold)
                              .make(),
                          subtitle: Row(
                            children: [
                              if (isFlashSaleExpired)
                                Text(
                                  '$oldPrice TND',
                                  style: const TextStyle(
                                    color: redColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              else if (hasDiscount)
                                Row(
                                  children: [
                                    Text(
                                      '$oldPrice TND',
                                      style: const TextStyle(
                                        color: darkFontGrey,
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '$discountedPrice TND',
                                      style: const TextStyle(
                                        color: redColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              if (!hasDiscount)
                                Text(
                                  '$oldPrice',
                                  style: const TextStyle(
                                    color: redColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.favorite,
                            color: redColor,
                          ).onTap(() async {
                            await firestore
                                .collection(productsCollection)
                                .doc(data[index].id)
                                .set({
                              'p_wishlist':
                                  FieldValue.arrayRemove([currentUser!.uid])
                            }, SetOptions(merge: true));
                          }),
                        );
                      }),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
