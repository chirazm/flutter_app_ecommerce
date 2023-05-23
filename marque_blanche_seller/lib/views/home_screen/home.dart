import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/controllers/home_controller.dart';
import 'package:marque_blanche_seller/views/coupon_screen/CouponScreen.dart';
import 'package:marque_blanche_seller/views/home_screen/home_screen.dart';
import 'package:marque_blanche_seller/views/orders_screen/orders_screen.dart';
import 'package:marque_blanche_seller/views/products_screen/products_screen.dart';
import 'package:marque_blanche_seller/views/profile_screen/profile_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var bottomNavBar = [
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          size: 28,
        ),
        label: dashboard,
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.apps_outlined,
          size: 28,
        ),
        label: products,
      ),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.article,
            size: 28,
          ),
          label: orders),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCoupons,
            color: darkGrey,
            width: 24,
          ),
          label: coupons),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            size: 28,
          ),
          label: settings,),
    ];

    var navScreens = [
      const HomeScreen(),
      const ProductsScreen(),
      const OrdersScreen(),
      const CouponScreen(),
      const ProfileScreen()
    ];
    return Scaffold(
      body: Column(
        children: [
          Obx(() => Expanded(
                child: navScreens.elementAt(controller.navIndex.value),
              )),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.navIndex.value,
          selectedItemColor: purpleColor,
          //selectedLabelStyle: const TextStyle(fontFamily: semibold),
          type: BottomNavigationBarType.fixed,
          backgroundColor: white,
          items: bottomNavBar,
          onTap: ((value) {
            controller.navIndex.value = value;
          }),
        ),
      ),
    );
  }
}
