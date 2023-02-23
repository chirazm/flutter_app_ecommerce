import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/consts/lists.dart';
import 'package:pfe_app/views/profile_screen/components/details_card.dart';
import 'package:pfe_app/widget_common/bg_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            //edit profile button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.edit,
                  color: whiteColor,
                ),
              ).onTap(() {}),
            ),
            //users details section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    imgProfile2,
                    width: 80,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make(),
                  10.widthBox,
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Dummy User".text.fontFamily(semibold).white.make(),
                      "customer@example.com".text.white.make(),
                    ],
                  )),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                      color: whiteColor,
                    )),
                    onPressed: () {},
                    child: logout.text.fontFamily(semibold).white.make(),
                  ),
                ],
              ),
            ),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                detailsCard(context.screenWidth / 3.3, "00", "in your cart"),
                detailsCard(
                    context.screenWidth / 3.3, "320", "in your wishlist"),
                detailsCard(context.screenWidth / 3.3, "14", "your orders"),
              ],
            ),

            //buttons section
            ListView.separated(
                    shrinkWrap: true,
                    itemCount: profileButtonList.length,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: lightGrey,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.asset(
                          profileButtonsIcon[index],
                          width: 22,
                        ),
                        title: profileButtonList[index]
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                      );
                    })
                .box
                .white
                .rounded
                .margin(const EdgeInsets.all(12))
                .padding(const EdgeInsets.symmetric(horizontal: 16))
                .shadowSm
                .make()
                .box
                .color(redColor)
                .make(),
          ],
        ),
      )),
    );
  }
}
