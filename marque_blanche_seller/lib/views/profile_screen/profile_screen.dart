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
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    var currentUser = Get.find<AuthController>().user;

    if (currentUser == null) {
      // If the current user is not available, return a loading indicator or handle the case accordingly
      return loadingIndicator(circleColor: white);
    }

    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, size: 16.0),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Get.to(() => EditProfileScreen(
          //           username: (controller.snapshotData.data()
          //               as dynamic)!['vendor_name'],
          //           snapshotData:
          //               controller.snapshotData.data() as Map<String, dynamic>?,
          //         ));
          //   },
          //   icon: const Icon(Icons.edit),
          // ),
          IconButton(
            onPressed: () async {
              await Get.find<AuthController>().signoutMethod(context);
              Get.offAll(() => const LoginScreen());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: StoreServices.getProfile(currentUser.uid),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingIndicator(circleColor: white);
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Profile not found'),
            );
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          if (userData == null) {
            return Center(
              child: Text('Invalid profile data'),
            );
          }

          return Column(
            children: [
              ListTile(
                leading: userData['imageUrl'] == ''
                    ? Image.asset(imgProduct)
                        .box
                        .roundedFull
                        .clip(Clip.antiAlias)
                        .make()
                    : Image.network(
                        userData['imageUrl'],
                        width: 100,
                      ).box.roundedFull.clip(Clip.antiAlias).make(),
                title: boldText(
                  text: "${userData['vendor_name']}",
                ),
                subtitle: normalText(text: "${userData['email']}"),
              ),
              const Divider(),
              10.heightBox,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: List.generate(
                    1,
                    (index) => ListTile(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => const ShopSettings());
                            break;

                          default:
                        }
                      },
                      leading: Icon(
                        profileButtonsIcons[index],
                        color: white,
                      ),
                      title: normalText(
                        text: profileButtonsTitles[index],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
