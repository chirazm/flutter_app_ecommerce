import 'package:admin_panel_pfe/views/screens/side_bar_screens/categories_screen.dart';
import 'package:admin_panel_pfe/views/screens/side_bar_screens/dashbord_screen.dart';
import 'package:admin_panel_pfe/views/screens/side_bar_screens/orders_screen.dart';
import 'package:admin_panel_pfe/views/screens/side_bar_screens/products_screen.dart';
import 'package:admin_panel_pfe/views/screens/side_bar_screens/upload_banner.dart';
import 'package:admin_panel_pfe/views/screens/side_bar_screens/vendors_screen.dart';
import 'package:admin_panel_pfe/views/screens/side_bar_screens/withdrawal_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        title: Text('Management'),
      ),
      sideBar: SideBar(
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
              icon: CupertinoIcons.add,
              route: UploadBanner.routeName),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSelector(item);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _selectedItem,
    );
  }
}
