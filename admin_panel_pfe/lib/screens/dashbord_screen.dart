import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:admin_panel_pfe/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = "\DashboardScreen";
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    Widget analyticWidget(
        {required String title, required String value, required Icon icon}) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 120,
          width: 220,
          decoration: BoxDecoration(
            border: Border.all(color: appbarColor),
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 252, 184, 210),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    icon,
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Icon(Icons.show_chart)
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Divider(
                thickness: 5,
              ),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _services.users.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.hasData) {
                        return analyticWidget(
                          title: 'Total User',
                          value: snapshot.data!.size.toString(),
                          icon: Icon(
                            CupertinoIcons.person_3_fill,
                            size: 35,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _services.vendors.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.cyan,
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return analyticWidget(
                            title: 'Total Vendor',
                            value: snapshot.data!.size.toString(),
                            icon: Icon(
                              CupertinoIcons.person_3_fill,
                              size: 35,
                            ));
                      }
                      return SizedBox();
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _services.category.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.hasData) {
                        return analyticWidget(
                          title: 'Total Category',
                          value: snapshot.data!.size.toString(),
                          icon: Icon(
                            Icons.category,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _services.orders.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.cyan,
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return analyticWidget(
                          title: 'Total Order',
                          value: snapshot.data!.size.toString(),
                          icon: Icon(
                            Icons.shopping_cart,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _services.products.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.hasData) {
                        return analyticWidget(
                          icon: Icon(
                            Icons.shop,
                          ),
                          title: 'Total Product',
                          value: snapshot.data!.size.toString(),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
