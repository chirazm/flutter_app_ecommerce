import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/home_controller.dart';
import 'package:pfe_app/models/product_model.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/views/category_screen/item_details.dart';
import 'package:pfe_app/views/home_screen/components/featured_button.dart';
import 'package:pfe_app/views/home_screen/components/home_buttons.dart';
import 'package:pfe_app/views/home_screen/search_screen.dart';
import 'package:pfe_app/views/sellers/list_sellers.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';
import '../../controllers/auth_controller.dart';
import '../auth_screen/login_screen.dart';
import 'components/count_down_Timer.dart';
import '../../consts/lists.dart';
import '../flash_sale_screen/flash_sale.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List _bannerImage = [];
  getBanners() {
    return _firestore
        .collection(bannersCollection)
        .get()
        .then((QuerySnapshot querySnapshot) {
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
    var controller = Get.find<HomeController>();
    return Container(
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      padding: const EdgeInsets.all(12),
      child: SafeArea(
          child: Column(
        children: [
          VxSwiper.builder(
            scrollDirection: Axis.horizontal,
            aspectRatio: 16 / 9,
            height: 60,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 500),
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return Align(
                alignment: Alignment.center,
                child: Text(
                  index == 0
                      ? 'Free Delivery On Orders > 99 TND'
                      : 'Free Delivery On Orders > 99 TND',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          Container(
            height: 50,
            alignment: Alignment.center,
            color: lightGrey,
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: const Icon(Icons.search).onTap(() {
                  if (controller.searchController.text.isNotEmptyAndNotNull) {
                    Get.to(() => SearchScreen(
                          title: controller.searchController.text,
                        ));
                  }
                }),
                filled: true,
                fillColor: whiteColor,
                hintText: searchanything,
                hintStyle: const TextStyle(color: textfieldGrey),
              ),
            ),
          ),

          10.heightBox,

          //swipers brands

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //swiper offers
                  10.heightBox,
                  VxSwiper.builder(
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    height: 150,
                    enlargeCenterPage: true,
                    itemCount: _bannerImage.length,
                    itemBuilder: (context, index) {
                      return _bannerImage.isEmpty
                          ? Container()
                          : Image.network(
                              _bannerImage[index].toString(),
                              fit: BoxFit.fill,
                            )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                    },
                  ),

                  //Deals buttons
                  20.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      2,
                      (index) => HomeButtons(
                          height: context.screenHeight * 0.15,
                          width: context.screenWidth / 2.5,
                          icon: index == 0 ? icSellers : icFlashDeal,
                          title: index == 0 ? sellers : flashsale,
                          onPressed: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SellerList()),
                              );
                            } else if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FlashSaleScreen()),
                              );
                            }
                          }),
                    ),
                  ),

                  //featured categories
                  20.heightBox,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: featuredCategories.text
                        .color(Colors.black)
                        .size(18)
                        .fontFamily(semibold)
                        .make(),
                  ),
                  10.heightBox,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        2,
                        (index) => Column(
                          children: [
                            featuredButton(
                                icon: featuredImages1[index],
                                category: featuredTitles1[index]),
                            10.heightBox,
                            featuredButton(
                                icon: featuredImages2[index],
                                category: featuredTitles2[index]),
                          ],
                        ),
                      ).toList(),
                    ),
                  ),

                  //featured product
                  20.heightBox,
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: const BoxDecoration(color: redColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        featuredProduct.text.white
                            .fontFamily(bold)
                            .size(18)
                            .make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                            future: FirestoreServices.getfeaturedProducts(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return loadingIndicator();
                              } else if (snapshot.data!.docs.isEmpty) {
                                return "No featured products"
                                    .text
                                    .white
                                    .makeCentered();
                              } else {
                                var featuredData = snapshot.data!.docs;
                                return Row(
                                  children: List.generate(featuredData.length,
                                      (index) {
                                    bool hasDiscount = featuredData[index]
                                            ['discountedPrice'] !=
                                        null;
                                    double oldPrice = double.parse(
                                        featuredData[index]['p_price']);
                                    double discountedPrice = hasDiscount
                                        ? double.parse(featuredData[index]
                                            ['discountedPrice'])
                                        : oldPrice;
                                    bool isFlashSaleExpired = hasDiscount &&
                                        featuredData[index]['endDate'] !=
                                            null &&
                                        DateTime.now().isAfter(
                                            featuredData[index]['endDate']
                                                .toDate());

                                    if (featuredData[index]['endDate'] ==
                                            null &&
                                        featuredData[index]
                                                ['discountedPrice'] ==
                                            "0.0") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            featuredData[index]['p_imgs'][0],
                                            width: 130,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                          10.heightBox,
                                          "${featuredData[index]['p_name']}"
                                              .text
                                              .fontFamily(semibold)
                                              .color(darkFontGrey)
                                              .make(),
                                          10.heightBox,
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
                                          .margin(const EdgeInsets.symmetric(
                                              horizontal: 4))
                                          .roundedSM
                                          .padding(const EdgeInsets.all(8))
                                          .make()
                                          .onTap(() {
                                        Get.to(() => ItemDetails(
                                              title:
                                                  "${featuredData[index]['p_name']}",
                                              data: featuredData[index],
                                            ));
                                      });
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          featuredData[index]['p_imgs'][0],
                                          width: 130,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        10.heightBox,
                                        "${featuredData[index]['p_name']}"
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
                                        else if (hasDiscount)
                                          Row(
                                            children: [
                                              Text(
                                                '$oldPrice TND',
                                                style: const TextStyle(
                                                  color: darkFontGrey,
                                                  fontSize: 16,
                                                  decoration: TextDecoration
                                                      .lineThrough,
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
                                        .margin(const EdgeInsets.symmetric(
                                            horizontal: 4))
                                        .roundedSM
                                        .padding(const EdgeInsets.all(8))
                                        .make()
                                        .onTap(() {
                                      Get.to(() => ItemDetails(
                                            title:
                                                "${featuredData[index]['p_name']}",
                                            data: featuredData[index],
                                          ));
                                    });
                                  }),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  //all products section
                  30.heightBox,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: allproducts.text
                        .fontFamily(bold)
                        .color(Colors.black)
                        .size(18)
                        .make(),
                  ),
                  20.heightBox,
                  StreamBuilder(
                    stream: FirestoreServices.allProducts(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return loadingIndicator();
                      } else {
                        var allproductsData = snapshot.data!.docs;
                        return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allproductsData.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 280,
                            ),
                            itemBuilder: (context, index) {
                              bool hasDiscount = allproductsData[index]
                                      ['discountedPrice'] !=
                                  null;
                              double oldPrice = double.parse(
                                  allproductsData[index]['p_price']);
                              double discountedPrice = hasDiscount
                                  ? double.parse(
                                      allproductsData[index]['discountedPrice'])
                                  : oldPrice;
                              bool isFlashSaleExpired = hasDiscount &&
                                  allproductsData[index]['endDate'] != null &&
                                  DateTime.now().isAfter(allproductsData[index]
                                          ['endDate']
                                      .toDate());

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    allproductsData[index]['p_imgs'][0],
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  const Spacer(),
                                  "${allproductsData[index]['p_name']}"
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
                                      allproductsData[index]['endDate'] != null)
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
                                  .padding(const EdgeInsets.all(12))
                                  .make()
                                  .onTap(() {
                                Get.to(
                                  () => ItemDetails(
                                    title:
                                        "${allproductsData[index]['p_name']}",
                                    data: allproductsData[index],
                                  ),
                                );
                              });
                            });
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
