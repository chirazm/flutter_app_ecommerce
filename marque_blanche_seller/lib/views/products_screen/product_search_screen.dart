import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/services/store_services.dart';
import 'package:marque_blanche_seller/views/products_screen/product_details.dart';

import '../../const/const.dart';

class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({Key? key, this.title, required this.currentUserId})
      : super(key: key);
  final String? title;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: darkGrey,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          title!,
          style: const TextStyle(color: darkGrey),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            StoreServices.searchProductsByNameForUser(title!, currentUserId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 300,
                ),
                itemCount: filtered.length,
                itemBuilder: (BuildContext context, int index) {
                  var product = filtered[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ProductDetails(
                            data: filtered[index],
                          ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['p_name'].toString(),
                          style: const TextStyle(
                            color: purpleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.network(
                          product['p_imgs'][0],
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        "${product['p_price']} TND"
                            .text
                            .color(purpleColor)
                            .fontWeight(FontWeight.bold)
                            .size(16)
                            .make(),
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
