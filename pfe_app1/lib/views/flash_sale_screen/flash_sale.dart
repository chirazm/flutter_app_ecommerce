import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/home_controller.dart';
import 'package:pfe_app/models/product_model.dart';

import 'package:get/get.dart';
import 'package:pfe_app/views/category_screen/item_details.dart';
import 'package:pfe_app/views/home_screen/components/count_down_Timer.dart';

class FlashSaleScreen extends StatefulWidget {
  const FlashSaleScreen({Key? key}) : super(key: key);

  @override
  _FlashSaleScreenState createState() => _FlashSaleScreenState();
}

class _FlashSaleScreenState extends State<FlashSaleScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _bannerImage = [];

  void getBanners() {
    _firestore.collection('banners').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _bannerImage.add(doc['image']);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: redColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
        title: "Flash Sale".text.color(whiteColor).fontFamily(semibold).make(),
      ),
      body: Container(
        color: whiteColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('endDate', isNull: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<Product> products = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return Product(
                  id: doc.id,
                  name: data['p_name'],
                  price: data['p_price'],
                  imageURL: data['p_imgs'][0],
                  endDate: data['endDate'] != null
                      ? (data['endDate'] as Timestamp).toDate()
                      : null,
                  quantity: '',
                );
              }).toList();

              List<Product> activeProducts = products.where((product) {
                DateTime now = DateTime.now();
                Duration remainingTime = product.endDate!.difference(now);
                return remainingTime.inDays >= -2;
              }).toList();

              if (activeProducts.isEmpty) {
                return const Center(
                  child: Text(
                    'No offers yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: activeProducts.length,
                itemBuilder: (context, index) {
                  Product product = activeProducts[index];
                  DateTime now = DateTime.now();
                  Duration remainingTime = product.endDate!.difference(now);
                  bool offerExpired =
                      remainingTime.isNegative || remainingTime.inSeconds == 0;

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ItemDetails(
                            title: product.name!,
                            data: snapshot.data!.docs[index],
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: lightGolden2,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                product.imageURL,
                                height: 240,
                                width: 320,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          offerExpired
                              ? Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.grey,
                                  child: const Text(
                                    'Offer expired',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : CountdownTimer(
                                  duration: remainingTime,
                                ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
