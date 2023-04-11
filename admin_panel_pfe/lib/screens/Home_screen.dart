import 'package:admin_panel_pfe/screens/categories_screen.dart';
import 'package:admin_panel_pfe/screens/dashbord_screen.dart';
import 'package:admin_panel_pfe/screens/products_screen.dart';
import 'package:admin_panel_pfe/screens/banners_screen.dart';
import 'package:admin_panel_pfe/screens/vendors_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../consts/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedItem = DashboardScreen();
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
      case CategoriesScreen.routeName:
        setState(() {
          setState(() {
            _selectedItem = CategoriesScreen();
          });
        });
        break;
      case ProductScreen.routeName:
        setState(() {
          setState(() {
            _selectedItem = ProductScreen();
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
    return AdminScaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text('Marque blanche Dashboard'),
      ),
      sideBar: SideBar(
        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w200),
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
              icon: CupertinoIcons.person_3,
              route: VendorsScreen.routeName),
          AdminMenuItem(
              title: 'Categories',
              icon: Icons.category,
              route: CategoriesScreen.routeName),
          AdminMenuItem(
              title: 'Products',
              icon: Icons.shop,
              route: ProductScreen.routeName),
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
              style: TextStyle(
                color: Colors.white,
              ),
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
    );
  }
}
