import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/models/seller_model.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/views/sellers/vendor_products.dart';

import '../../controllers/home_controller.dart';

import '../home_screen/home.dart';

class SellerList extends StatefulWidget {
  const SellerList({Key? key}) : super(key: key);

  @override
  _SellerListState createState() => _SellerListState();
}

class _SellerListState extends State<SellerList> {
  late Future<List<Seller>> sellersFuture;

  @override
  void initState() {
    super.initState();
    sellersFuture = FirestoreServices.getSellers();
  }

  var controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
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
        title: "List of Sellers"
            .text
            .color(whiteColor)
            .fontFamily(semibold)
            .make(),
      ),
      body: FutureBuilder<List<Seller>>(
        future: sellersFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Seller>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<Seller> sellers = snapshot.data!;

            return ListView.builder(
              itemCount: sellers.length,
              itemBuilder: (BuildContext context, int index) {
                Seller seller = sellers[index];

                return ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    child: Image.network(seller.image, fit: BoxFit.cover),
                  ),
                  title: Text(
                    seller.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text('Number of products : ${seller.numberOfProducts}'),
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(
                          () => VendorProductsPage(vendorId: seller.vendorId));
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: darkFontGrey,
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No sellers found.'),
            );
          }
        },
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
