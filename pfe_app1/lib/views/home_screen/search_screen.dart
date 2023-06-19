import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/colors.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/views/category_screen/item_details.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, this.title});
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).make(),
      ),
      body: FutureBuilder(
          future: FirestoreServices.searchProducts(title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No products found.".text.makeCentered();
            } else {
              var data = snapshot.data!.docs;

              var filtered = data
                  .where(
                    (element) => element['p_name']
                        .toString()
                        .toLowerCase()
                        .contains(title!.toLowerCase()),
                  )
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= filtered.length) {
                      return const SizedBox();
                    }
                    bool hasDiscount =
                        filtered[index]['discountedPrice'] != null;
                    double price = double.parse(filtered[index]['p_price']);
                    double discountedPrice = hasDiscount
                        ? double.parse(filtered[index]['discountedPrice'])
                        : price;
                    double oldPrice = double.parse(filtered[index]['p_price']);
                    bool isFlashSaleExpired = hasDiscount &&
                        filtered[index]['endDate'] != null &&
                        DateTime.now()
                            .isAfter(filtered[index]['endDate'].toDate());

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          filtered[index]['p_imgs'][0],
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        const Spacer(),
                        "${filtered[index]['p_name']}"
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                        10.heightBox,
                        if (isFlashSaleExpired)
                          Text(
                            '$oldPrice TND',
                            style: const TextStyle(
                              color: redColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        else if (hasDiscount &&
                            filtered[index]['endDate'] != null)
                          Row(
                            children: [
                              Text(
                                '$oldPrice TND',
                                style: const TextStyle(
                                  color: darkFontGrey,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$discountedPrice TND',
                                style: const TextStyle(
                                  color: redColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            '$oldPrice TND',
                            style: const TextStyle(
                              color: redColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        10.heightBox,
                      ],
                    )
                        .box
                        .white
                        .margin(const EdgeInsets.symmetric(horizontal: 4))
                        .outerShadowMd
                        .padding(const EdgeInsets.all(12))
                        .make()
                        .onTap(() {
                      Get.to(() => ItemDetails(
                            title: "${filtered[index]['p_name']}",
                            data: filtered[index],
                          ));
                    });
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 300),
                ),
              );
            }
          }),
    );
  }
}
