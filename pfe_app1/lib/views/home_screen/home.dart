import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/home_controller.dart';
import 'package:pfe_app/views/cart_screen/cart_screen.dart';
import 'package:pfe_app/views/category_screen/category_screen.dart';
import 'package:pfe_app/views/home_screen/home_screen.dart';
import 'package:pfe_app/views/profile_screen/profile_screen.dart';
import 'package:pfe_app/widget_common/exit_dialog.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    //init home controller
    var controller = Get.put(HomeController());
    var navbarItem = [
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: home),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.category,
            size: 30,
          ),
          label: categories),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart,
            size: 30,
          ),
          label: cart),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
            size: 30,
          ),
          label: account),
    ];

    var navBody = [
      const HomeScreen(),
      const CategoryScreen(),
      CartScreen(),
      const ProfileScreen()
    ];
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => exitDialog(context));
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(() => Expanded(
                  child: navBody.elementAt(controller.currentNavIndex.value),
                )),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            selectedItemColor: redColor,
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            items: navbarItem,
            onTap: ((value) {
              controller.currentNavIndex.value = value;
            }),
          ),
        ),
      ),
    );
  }
}
