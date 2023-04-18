import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/consts/lists.dart';
import 'package:pfe_app/controllers/product_controller.dart';
import 'package:pfe_app/views/category_screen/category_details.dart';
import 'package:pfe_app/widget_common/bg_widget.dart';

import '../../services/firestore_services.dart';
import '../../widget_common/loading_indicator.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //late dynamic categorySnapshot;
    var controller = Get.put(ProductController());
    return bgWidget(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: categories.text.fontFamily(bold).white.make(),
      ),
      body: FutureBuilder(
          future: FirestoreServices.getCategories(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "Categories is empty".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              return Container(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 200),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Image.network(
                          "${data[index]['image']}",
                          height: 120,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        10.heightBox,
                        "${data[index]['name']}"
                            .text
                            .color(Colors.black)
                            .align(TextAlign.center)
                            .make(),
                      ],
                    )
                        .box
                        .white
                        .rounded
                        .clip(Clip.antiAlias)
                        .outerShadowSm
                        .make()
                        .onTap(() {
                      controller.getSubCategories(categoriesList[index]);
                      Get.to(() => CategoryDetails(
                            title: "${data[index]['name']}",
                            data: data[index],
                          ));
                    });
                  },
                ),
              );
            }
          }),
    ));
  }
}
