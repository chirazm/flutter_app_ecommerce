import 'package:get/get.dart';
import 'package:marque_blanche_seller/views/messages_screen/messages_screen.dart';
import 'package:marque_blanche_seller/views/profile_screen/edit_profile_screen.dart';
import 'package:marque_blanche_seller/views/shop_screen.dart/shop_settings_screen.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

import '../../const/const.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, size: 16.0),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EditProfileScreen());
              },
              icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: Image.asset(imgProduct)
                .box
                .roundedFull
                .clip(Clip.antiAlias)
                .make(),
            title: boldText(text: "Vendor name"),
            subtitle: normalText(text: "vendoremail@emart.com"),
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
                        title: normalText(text: profileButtonsTitles[index]),
                      )),
            ),
          )
        ],
      ),
    );
  }
}
