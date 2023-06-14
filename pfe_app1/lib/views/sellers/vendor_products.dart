import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/models/product_model.dart';
import 'package:pfe_app/models/product_model2.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/views/category_screen/item_details.dart';
import 'package:pfe_app/views/home_screen/home.dart';

import '../home_screen/components/item_details2.dart';

class VendorProductsPage extends StatelessWidget {
  final String vendorId;

  VendorProductsPage({Key? key, required this.vendorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: redColor,
        title: Text('Vendor Products'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
      ),
      body: Container(
        // Fetch and display the products of the selected vendor
        child: FutureBuilder<List<Product2>>(
          future: FirestoreServices.fetchVendorProducts2(vendorId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product2> products = snapshot.data!;

              return GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 280,
                ),
                itemBuilder: (context, index) {
                  Product2 product = products[index];
                  bool hasDiscount = product.flashSalePrice != null;
                  double oldPrice = double.parse(product.oldPrice);
                  bool isFlashSaleExpired = hasDiscount &&
                      product.endDate != null &&
                      DateTime.now().isAfter(product.endDate!.toDate());

                  double discountedPrice = hasDiscount
                      ? double.parse(product.flashSalePrice)
                      : oldPrice;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        product.imageURL,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      const Spacer(),
                      Text(
                        product.name!,
                        style: const TextStyle(
                          fontFamily: semibold,
                          color: darkFontGrey,
                        ),
                      ),
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
                      else if (hasDiscount && product.endDate != null)
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
                      .roundedSM
                      .padding(const EdgeInsets.all(12))
                      .make()
                      .onTap(
                    () {
                      Get.to(
                        () => ItemDetails2(
                          product2: product,
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: redColor,
        onPressed: () {
          Get.offAll(() => Home());
        },
        child: const Icon(
          Icons.home,
          color: whiteColor,
        ),
      ),
    );
  }
}
