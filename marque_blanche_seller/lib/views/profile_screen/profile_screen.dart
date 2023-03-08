import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/controllers/auth_controller.dart';
import 'package:marque_blanche_seller/controllers/profile_controller.dart';
import 'package:marque_blanche_seller/services/store_services.dart';
import 'package:marque_blanche_seller/views/auth_screen/login_screen.dart';
import 'package:marque_blanche_seller/views/messages_screen/messages_screen.dart';
import 'package:marque_blanche_seller/views/profile_screen/edit_profile_screen.dart';
import 'package:marque_blanche_seller/views/shop_screen.dart/shop_settings_screen.dart';
import 'package:marque_blanche_seller/views/widgets/loading_indicator.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

import '../../const/const.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, size: 16.0),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EditProfileScreen(
                      username: controller.snapshotData['vendor_name'],
                    ));
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                await Get.find<AuthController>().signoutMethod(context);
                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder(
          future: StoreServices.getProfile(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator(circleColor: white);
            } else {
              controller.snapshotData = snapshot.data!.docs[0];

              return Column(
                children: [
                  ListTile(
                    leading: controller.snapshotData['imageUrl'] == ''
                        ? Image.asset(imgProduct)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make()
                        : Image.network(
                            controller.snapshotData['imageUrl'],
                            width: 100,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                    title: boldText(
                        text: "${controller.snapshotData['vendor_name']}"),
                    subtitle:
                        normalText(text: "${controller.snapshotData['email']}"),
                  ),
                  const Divider(),
                  10.heightBox,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(
                          2,
                          (index) => ListTile(
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      Get.to(() => const ShopSettings());
                                      break;
                                    case 1:
                                      Get.to(() => const MessagesScreen());
                                      break;
                                    default:
                                  }
                                },
                                leading: Icon(
                                  profileButtonsIcons[index],
                                  color: white,
                                ),
                                title: normalText(
                                    text: profileButtonsTitles[index]),
                              )),
                    ),
                  )
                ],
              );
            }
          }),
      //
    );
  }
}
