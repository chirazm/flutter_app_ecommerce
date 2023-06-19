import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marque_blanche_seller/views/widgets/appbar_widget.dart';

import '../../const/strings.dart';
import '../products_screen/product_details.dart';

class FlashSaleProductsScreen extends StatefulWidget {
  @override
  _FlashSaleProductsScreenState createState() =>
      _FlashSaleProductsScreenState();
}

class _FlashSaleProductsScreenState extends State<FlashSaleProductsScreen> {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(flashSales),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('vendor_id', isEqualTo: currentUserId)
            .orderBy('endDate', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          List<QueryDocumentSnapshot> filteredProducts = [];

          documents.forEach((product) {
            Map<String, dynamic>? data =
                product.data() as Map<String, dynamic>?;
            if (data != null && data.containsKey('endDate')) {
              Timestamp? endDateTimestamp = data['endDate'] as Timestamp?;
              if (endDateTimestamp != null) {
                DateTime endDate = endDateTimestamp.toDate();
                DateTime now = DateTime.now();
                DateTime twoDaysAfterEndDate =
                    endDate.add(const Duration(days: 2));
                bool isExpired = now.isAfter(twoDaysAfterEndDate);

                if (!isExpired) {
                  filteredProducts.add(product);
                }
              }
            }
          });

          return ListView.separated(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot product = filteredProducts[index];
              Map<String, dynamic>? data =
                  product.data() as Map<String, dynamic>?;
              if (data != null && data.containsKey('endDate')) {
                Timestamp? endDateTimestamp = data['endDate'] as Timestamp?;
                String discountPrice = data['discountedPrice'] as String;
                if (endDateTimestamp != null) {
                  DateTime endDate = endDateTimestamp.toDate();

                  return ListTile(
                    onTap: () {
                      navigateToProductDetails(data);
                    },
                    leading: GestureDetector(
                      onTap: () {
                        navigateToProductDetails(data);
                      },
                      child: Image.network(data['p_imgs'][0]),
                    ),
                    title: SizedBox(
                      height: 25,
                      child: Text(
                        data['p_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discount Price: $discountPrice',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'End Date: ${DateFormat('dd/MM/yyyy HH:mm').format(endDate)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return const SizedBox.shrink();
              }
            },
            separatorBuilder: (context, index) => const SizedBox(height: 18.0),
          );
        },
      ),
    );
  }

  void navigateToProductDetails(Map<String, dynamic> productData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(data: productData),
      ),
    );
  }
}
