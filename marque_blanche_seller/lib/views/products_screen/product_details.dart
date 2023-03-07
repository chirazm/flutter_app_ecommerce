import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkGrey,
            )),
        title: boldText(text: "Product title", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
                autoPlay: true,
                height: 310,
                itemCount: 3,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                itemBuilder: (context, index) {
                  //image
                  return Image.asset(
                    imgProduct,
                    //data["p_imgs"][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }),
            10.heightBox,

            //title and details section
            boldText(text: "Product title", color: fontGrey, size: 16.0),

            10.heightBox,

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title and details section
                  boldText(text: "Product title", color: fontGrey, size: 16.0),

                  10.heightBox,
                  //rating
                  VxRating(
                    isSelectable: false,
                    //value: double.parse(data['p_rating']),
                    value: 3.0,
                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    selectionColor: golden,
                    count: 5,
                    size: 25,
                    maxRating: 5,
                  ),
                  10.heightBox,
                  boldText(text: "300.0", color: red, size: 16.0),
                  20.heightBox,
                  //color section
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(text: "Color", color: fontGrey),
                          ),
                          Row(
                            children: List.generate(
                              3,
                              (index) => VxBox()
                                  .size(40, 40)
                                  .roundedFull
                                  .color(Vx.randomPrimaryColor)
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 4))
                                  .make()
                                  .onTap(() {}),
                            ),
                          ),
                        ],
                      ),
                      10.heightBox,
                      //quantity row
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(text: "Quantity", color: fontGrey),
                          ),
                          normalText(text: "20 items", color: fontGrey),
                        ],
                      ),
                    ],
                  ).box.padding(const EdgeInsets.all(8)).make(),
                  const Divider(),
                  20.heightBox,
                  //description section
                  boldText(text: "Description", color: fontGrey),

                  10.heightBox,
                  normalText(text: "Description of this item", color: fontGrey)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
