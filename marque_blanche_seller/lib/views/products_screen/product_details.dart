import 'package:get/get.dart';

import '../../const/const.dart';
import '../flash_sale_screen/flash_sale_add.dart';
import '../widgets/our_button.dart';
import '../widgets/text_style.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasDiscount = data['discountedPrice'] != null;
    double oldPrice = double.parse(data['p_price']);
    double discountedPrice =
        hasDiscount ? double.parse(data['discountedPrice']) : oldPrice;
    bool isFlashSaleExpired = hasDiscount &&
        data['endDate'] != null &&
        DateTime.now().isAfter(data['endDate'].toDate());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: darkGrey,
          ),
        ),
        title: boldText(
          text: "${data['p_name']}",
          color: fontGrey,
          size: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VxSwiper.builder(
                autoPlay: true,
                height: 310,
                itemCount: data['p_imgs'].length,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                itemBuilder: (context, index) {
                  return Image.network(
                    data["p_imgs"][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),

              // Title and details section
              20.heightBox,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(
                      text: "${data['p_name']}",
                      color: darkGrey,
                      size: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    10.heightBox,
                    boldText(
                      text: "${data['p_category']}",
                      color: fontGrey,
                      size: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                    10.heightBox,
                    normalText(
                      text: "${data['p_subcategory']}",
                      color: fontGrey,
                      size: 16.0,
                    ),

                    10.heightBox,
                    if (isFlashSaleExpired)
                      Text(
                        '$oldPrice TND',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    else if (hasDiscount && data['endDate'] != null)
                      Row(
                        children: [
                          Text(
                            '$oldPrice TND',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$discountedPrice TND',
                            style: const TextStyle(
                              color: green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        '$oldPrice TND',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    15.heightBox,

                    // Color section
                    Column(
                      children: [
                        10.heightBox,
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: boldText(
                                text: "Quantity : ",
                                color: fontGrey,
                                size: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            normalText(
                              text: "${data['p_quantity']} items",
                              color: darkGrey,
                              size: 15.5,
                            ),
                          ],
                        ),
                      ],
                    ).box.padding(const EdgeInsets.all(8)).make(),
                    const Divider(),
                    20.heightBox,

                    // Description section
                    boldText(
                      text: "Description",
                      color: fontGrey,
                      size: 17.5,
                      fontWeight: FontWeight.w600,
                    ),
                    10.heightBox,
                    normalText(
                      text: "${data['p_desc']}",
                      color: darkGrey,
                      size: 15.5,
                    ),
                    30.heightBox,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        width: context.screenWidth,
        height: 60,
        child: ourButton(
          color: purpleColor,
          onPress: () {
            Get.to(() => FlashSaleAddProduct(
                  productId: data['id'],
                  productName: data['p_name'],
                  productImageURL: data['p_imgs'][0],
                ));
          },
          title: "Add Flash Sale",
        ),
      ),
    );
  }
}
