import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/consts/lists.dart';
import 'package:pfe_app/controllers/auth_controller.dart';
import 'package:pfe_app/controllers/profile_controller.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/views/auth_screen/login_screen.dart';
import 'package:pfe_app/views/chat_screen/messaging_screen.dart';
import 'package:pfe_app/views/orders_screen/orders_screen.dart';
import 'package:pfe_app/views/profile_screen/components/details_card.dart';
import 'package:pfe_app/views/profile_screen/edit_profile.dart';
import 'package:pfe_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:pfe_app/widget_common/bg_widget.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];
              return SafeArea(
                child: Column(
                  children: [
                    //edit profile button
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                        ),
                      ).onTap(() {
                        controller.nameController.text = data['name'];
                        Get.to(() => EditProfileScreen(data: data));
                      }),
                    ),

                    //users details section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == ''
                              ? Image.asset(
                                  imgProfile,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make()
                              : Image.network(
                                  data['imageUrl'],
                                  width: 80,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make(),
                          10.widthBox,
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .white
                                  .make(),
                              "${data['email']}".text.white.make(),
                            ],
                          )),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                              color: whiteColor,
                            )),
                            onPressed: () async {
                              await Get.put(AuthController())
                                  .signoutMethod(context);
                              Get.offAll(() => const LoginScreen());
                            },
                            child:
                                logout.text.fontFamily(semibold).white.make(),
                          ),
                        ],
                      ),
                    ),
                    20.heightBox,

                    FutureBuilder(
                      future: FirestoreServices.getCounts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: loadingIndicator(),
                          );
                        } else {
                          var countData = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              detailsCard(context.screenWidth / 3.3,
                                  countData[0].toString(), "in your cart"),
                              detailsCard(context.screenWidth / 3.3,
                                  countData[1].toString(), "in your wishlist"),
                              detailsCard(context.screenWidth / 3.3,
                                  countData[2].toString(), "your orders"),
                            ],
                          );
                        }
                      },
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     detailsCard(context.screenWidth / 3.3,
                    //         data['cart_count'], "in your cart"),
                    //     detailsCard(context.screenWidth / 3.3,
                    //         data['wishlist_count'], "in your wishlist"),
                    //     detailsCard(context.screenWidth / 3.3,
                    //         data['order_count'], "your orders"),
                    //   ],
                    // ),

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
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      Get.to(() => OrdersScreen());
                                      break;
                                    case 1:
                                      Get.to(() => WishlistScreen());
                                      break;
                                    case 2:
                                      Get.to(() => MessagesScreen());
                                      break;
                                  }
                                },
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
              );
            }
          },
        ),
      ),
    );
  }
}
