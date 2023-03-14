import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

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
        title: boldText(
            text: "${data['p_name']}",
            color: fontGrey,
            size: 18.0,
            FontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
                autoPlay: true,
                height: 310,
                itemCount: data['p_imgs'].length,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                itemBuilder: (context, index) {
                  //image
                  return Image.network(
                    data["p_imgs"][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }),

            //title and details section
            20.heightBox,

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title and details section
                  boldText(
                      text: "${data['p_name']}",
                      color: darkGrey,
                      size: 20.0,
                      FontWeight: FontWeight.bold),

                  10.heightBox,

                  boldText(
                      text: "${data['p_category']}",
                      color: fontGrey,
                      size: 17.0,
                      FontWeight: FontWeight.w600),
                  10.heightBox,
                  normalText(
                      text: "${data['p_subcategory']}",
                      color: fontGrey,
                      size: 16.0),

                  10.heightBox,
                  //rating
                  VxRating(
                    isSelectable: false,
                    //value: double.parse(data['p_rating']),
                    value: double.parse(data['p_rating']),
                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    selectionColor: golden,
                    count: 5,
                    size: 25,
                    maxRating: 5,
                  ),
                  10.heightBox,
                  boldText(
                      text: "${data['p_price']} TND",
                      color: red,
                      size: 17.0,
                      FontWeight: FontWeight.w500),
                  20.heightBox,
                  //color section
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(
                                text: "Color",
                                color: fontGrey,
                                size: 17.5,
                                FontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: List.generate(
                              data['p_colors'].length,
                              (index) => VxBox()
                                  .size(40, 40)
                                  .roundedFull
                                  .color(Color(data['p_colors'][index]))
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
                            child: boldText(
                                text: "Quantity",
                                color: fontGrey,
                                size: 17.5,
                                FontWeight: FontWeight.w600),
                          ),
                          normalText(
                              text: "${data['p_quantity']} items",
                              color: darkGrey,
                              size: 15.5),
                        ],
                      ),
                    ],
                  ).box.padding(const EdgeInsets.all(8)).make(),
                  const Divider(),
                  20.heightBox,
                  //description section
                  boldText(
                      text: "Description",
                      color: fontGrey,
                      size: 17.5,
                      FontWeight: FontWeight.w600),

                  10.heightBox,
                  normalText(
                      text: "${data['p_desc']}", color: darkGrey, size: 15.5)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
