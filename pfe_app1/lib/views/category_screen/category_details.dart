import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/product_controller.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/views/category_screen/item_details.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';
import 'package:pfe_app/controllers/home_controller.dart';
import 'package:pfe_app/views/home_screen/home.dart';
import '../../widget_common/bg_widget.dart';

class CategoryDetails extends StatefulWidget {
  final String title;
  final dynamic data;

  const CategoryDetails({
    Key? key,
    required this.title,
    this.data,
  }) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  late Stream<QuerySnapshot> productMethod;
  final controller = Get.find<ProductController>();
  final controller1 = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
    controller.selectSubcategory(controller.subcat[0]);
  }

  void switchCategory(String title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontFamily: bold),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: List.generate(
                  controller.subcat.length,
                  (index) {
                    final subcategory = controller.subcat[index];
                    final isSelected =
                        controller.selectedSubcategory.value == subcategory;
                    final textColor = isSelected ? darkFontGrey : darkFontGrey;
                    final backgroundColor = isSelected ? golden : whiteColor;
                    final textFamily = isSelected ? bold : semibold;
                    final textSize = isSelected ? 15.0 : 13.0;
                    return GestureDetector(
                      onTap: () {
                        controller.selectSubcategory(subcategory);
                        switchCategory(subcategory);
                        setState(() {});
                      },
                      child: Container(
                        width: 140,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          subcategory,
                          style: TextStyle(
                            fontSize: textSize,
                            fontFamily: textFamily,
                            color: textColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: productMethod,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: loadingIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No products found!',
                        style: TextStyle(color: darkFontGrey),
                      ),
                    );
                  } else {
                    var data = snapshot.data!.docs;
                    return ListView(
                      children: [
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 250,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            var product = data[index];

                            bool hasDiscount =
                                product['discountedPrice'] != null;
                            double oldPrice = double.parse(product['p_price']);
                            double discountedPrice = hasDiscount
                                ? double.parse(product['discountedPrice'])
                                : oldPrice;
                            bool isFlashSaleExpired = hasDiscount &&
                                product['endDate'] != null &&
                                DateTime.now()
                                    .isAfter(product['endDate'].toDate());

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  product['p_imgs'][0],
                                  height: 150,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                10.heightBox,
                                Text(
                                  product['p_name'],
                                  style: const TextStyle(
                                    fontFamily: bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 18),
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
                                    product['endDate'] != null)
                                  Row(
                                    children: [
                                      Text(
                                        '$oldPrice TND',
                                        style: const TextStyle(
                                          color: darkFontGrey,
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough,
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
                              ],
                            )
                                .box
                                .white
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 4))
                                .roundedSM
                                .outerShadowSm
                                .padding(const EdgeInsets.all(8))
                                .make()
                                .onTap(() {
                              controller.checkIfFav(product);
                              Get.to(
                                () => ItemDetails(
                                  title: product['p_name'],
                                  data: product,
                                ),
                              );
                            });
                          },
                        ),
                      ],
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
}
