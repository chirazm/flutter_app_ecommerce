import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/home_controller.dart';
import 'package:pfe_app/models/product_model.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/views/category_screen/item_details.dart';
import 'package:pfe_app/views/home_screen/components/featured_button.dart';
import 'package:pfe_app/views/home_screen/search_screen.dart';
import 'package:pfe_app/widget_common/home_buttons.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';
import 'components/count_down_Timer.dart';
import '../../consts/lists.dart';

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
          Container(
            height: 60,
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
                  //limited time offers
                  10.heightBox,
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('endDate', isNull: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<Product> products = snapshot.data!.docs.map((doc) {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          return Product(
                            id: doc.id,
                            name: data['p_name'],
                            price: data['p_price'],
                            imageURL: data['p_imgs'][0],
                            endDate: data['endDate'] != null
                                ? (data['endDate'] as Timestamp).toDate()
                                : null,
                          );
                        }).toList();

                        bool hasLimitedTimeOffers = products.isNotEmpty &&
                            products.any((product) => product.endDate != null);

                        PageController pageController =
                            PageController(initialPage: 0);

                        return Column(
                          children: [
                            Visibility(
                              visible: hasLimitedTimeOffers,
                              child: Column(
                                children: [
                                  const Text(
                                    'Limited-time Offers',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 270,
                                    child: PageView.builder(
                                      controller: pageController,
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        Product product = products[index];
                                        DateTime now = DateTime.now();
                                        Duration remainingTime =
                                            product.endDate!.difference(now);
                                        bool offerExpired =
                                            remainingTime.isNegative ||
                                                remainingTime.inSeconds == 0;

                                        String formattedTime = offerExpired
                                            ? 'Offer expired'
                                            : '${remainingTime.inDays}d: ${remainingTime.inHours.remainder(24)}h: ${remainingTime.inMinutes.remainder(60)}m: ${remainingTime.inSeconds.remainder(60)}s';

                                        return GestureDetector(
                                          onTap: () {
                                            var offeredData =
                                                snapshot.data!.docs;

                                            Get.to(
                                              () => ItemDetails(
                                                title:
                                                    "${offeredData[index]['p_name']}",
                                                data: offeredData[index],
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              25.widthBox,
                                              Visibility(
                                                visible: hasLimitedTimeOffers,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: redColor,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.arrow_back,
                                                    ),
                                                    onPressed: () {
                                                      pageController.previousPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve: Curves.ease);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              45.widthBox,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.network(
                                                    product.imageURL!,
                                                    height: 150,
                                                    width: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  10.heightBox,
                                                  Text(
                                                    product.name!,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    product.price.numCurrency
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: redColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  offerExpired
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          color: Colors.grey,
                                                          child: const Text(
                                                            'Offer expired',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        )
                                                      : CountdownTimer(
                                                          duration:
                                                              remainingTime,
                                                        ),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                              45.widthBox,
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: redColor,
                                                child: Visibility(
                                                  visible: hasLimitedTimeOffers,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.arrow_forward),
                                                    onPressed: () {
                                                      pageController.nextPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve: Curves.ease);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !hasLimitedTimeOffers,
                              child: Container(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _bannerImage.length,
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      _bannerImage[index].toString(),
                                      fit: BoxFit.fill,
                                    )
                                        .box
                                        .rounded
                                        .clip(Clip.antiAlias)
                                        .margin(const EdgeInsets.symmetric(
                                            horizontal: 8))
                                        .make();
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),

                  //featured categories
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
                        3,
                        (index) => Column(
                          children: [
                            featuredButton(
                                icon: featuredImages1[index],
                                title: featuredTitles1[index]),
                            10.heightBox,
                            featuredButton(
                                icon: featuredImages2[index],
                                title: featuredTitles2[index]),
                          ],
                        ),
                      ).toList(),
                    ),
                  ),

                  //swiper offers
                  20.heightBox,
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

                  //featured product
                  30.heightBox,
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
                                  return "No fearured products"
                                      .text
                                      .white
                                      .makeCentered();
                                } else {
                                  var featuredData = snapshot.data!.docs;
                                  return Row(
                                    children: List.generate(
                                        featuredData.length,
                                        (index) => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                  featuredData[index]['p_imgs']
                                                      [0],
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
                                                "${featuredData[index]['p_price']} TND"
                                                    .text
                                                    .color(redColor)
                                                    .fontFamily(semibold)
                                                    .size(16)
                                                    .make(),
                                                10.heightBox,
                                              ],
                                            )
                                                .box
                                                .white
                                                .margin(
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4))
                                                .roundedSM
                                                .padding(
                                                    const EdgeInsets.all(8))
                                                .make()
                                                .onTap(() {
                                              Get.to(() => ItemDetails(
                                                    title:
                                                        "${featuredData[index]['p_name']}",
                                                    data: featuredData[index],
                                                  ));
                                            })),
                                  );
                                }
                              }),
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
                                    mainAxisExtent: 280),
                            itemBuilder: ((context, index) {
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
                                  "${allproductsData[index]['p_price']} TND"
                                      .text
                                      .color(redColor)
                                      .fontFamily(semibold)
                                      .size(16)
                                      .make(),
                                  10.heightBox,
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
                                Get.to(() => ItemDetails(
                                      title:
                                          "${allproductsData[index]['p_name']}",
                                      data: allproductsData[index],
                                    ));
                              });
                            }));
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
