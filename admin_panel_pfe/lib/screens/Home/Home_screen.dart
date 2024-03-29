import 'package:admin_panel_pfe/screens/login/Login_screen.dart';
import 'package:admin_panel_pfe/screens/category/categories_screen.dart';
import 'package:admin_panel_pfe/screens/dashboard/dashbord_screen.dart';
import 'package:admin_panel_pfe/screens/customer/customer_screen.dart';
import 'package:admin_panel_pfe/screens/banner/banners_screen.dart';
import 'package:admin_panel_pfe/screens/vendor/vendors_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../../consts/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedItem = DashboardScreen();
  final user = FirebaseAuth.instance.currentUser!;
  Future logout() async {
    await await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false));
  }

  Future<void> exitDialog() {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: Text("Are you sure ?"),
              content: Text("Do you want to exit from the app ?"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  child: Text('EXIT'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('CANCEL'),
                ),
              ],
            ));
  }

  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = DashboardScreen();
        });
        break;
      case VendorsScreen.routeName:
        setState(() {
          setState(() {
            _selectedItem = VendorsScreen();
          });
        });
        break;
      case CustomersScreen.routeName:
        setState(() {
          setState(() {
            _selectedItem = CustomersScreen();
          });
        });
        break;
      case CategoriesScreen.routeName:
        setState(() {
          setState(() {
            _selectedItem = CategoriesScreen();
          });
        });
        break;

      case UploadBanner.routeName:
        setState(() {
          setState(() {
            _selectedItem = UploadBanner();
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exitDialog();
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: AdminScaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: appbarColor,
          title: Text('Shop App'),
          actions: [
            IconButton(
                onPressed: () {
                  exitDialog();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        sideBar: SideBar(
          textStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
          //activeBackgroundColor: Color.fromARGB(66, 224, 4, 4),
          borderColor: Color.fromARGB(255, 194, 192, 192),
          iconColor: Colors.black87,
          //activeIconColor: Color.fromARGB(255, 228, 86, 31),

          items: [
            AdminMenuItem(
                title: 'Dashboard',
                icon: Icons.dashboard,
                route: DashboardScreen.routeName),
            AdminMenuItem(
                title: 'Vendors',
                icon: CupertinoIcons.person_3_fill,
                route: VendorsScreen.routeName),
            AdminMenuItem(
                title: 'Customers',
                icon: CupertinoIcons.person_2_fill,
                route: CustomersScreen.routeName),
            AdminMenuItem(
                title: 'Categories',
                icon: Icons.category,
                route: CategoriesScreen.routeName),
            AdminMenuItem(
                title: 'Upload Banners',
                icon: CupertinoIcons.photo,
                route: UploadBanner.routeName),
          ],

          selectedRoute: '',
          onSelected: (item) {
            screenSelector(item);
          },
          header: Container(
            height: 50,
            width: double.infinity,
            color: Color.fromARGB(255, 155, 154, 154),
            child: const Center(
              child: Text(
                'Menu',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          footer: Container(
            height: 50,
            width: double.infinity,
            color: Color.fromARGB(255, 155, 154, 154),
            child: Center(
                child: Image.asset(
              'app_logo.png',
              width: 40,
              height: 40,
            )),
          ),
        ),
        body: _selectedItem,
      ),
    );
  }
}
