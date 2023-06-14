import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/views/category_screen/category_details.dart';

Widget featuredButton({String? category, icon}) {
  return GestureDetector(
    onTap: () {
      if (category == womenDress) {
        Get.to(() => CategoryDetails(
              title: category,
              data: category,
            ));
      } else {
        // Handle other categories here
      }
    },
    child: Row(
      children: [
        Image.asset(
          icon,
          width: 40,
          fit: BoxFit.fill,
        ),
        10.widthBox,
        category!.text.fontFamily(semibold).color(darkFontGrey).make(),
      ],
    )
        .box
        .width(200)
        .margin(const EdgeInsets.symmetric(horizontal: 4))
        .white
        .padding(const EdgeInsets.all(4))
        .roundedSM
        .outerShadowSm
        .make()
        .onTap(() {
      Get.to(() => CategoryDetails(
            title: category,
            data: category,
          ));
    }),
  );
}
