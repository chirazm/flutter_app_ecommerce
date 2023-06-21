import 'package:admin_panel_pfe/controllers/dashboard_controller.dart';
import 'package:admin_panel_pfe/screens/dashboard/dashboard_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

import '../../services/firebase_service.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = "\DashboardScreen";

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    Widget _buildLegendItem(String text, Color color) {
      return Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      );
    }

    Widget _buildLegend() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegendItem('Featured Product', Colors.indigo),
          SizedBox(height: 10),
          _buildLegendItem('Other Products', Colors.deepOrange),
        ],
      );
    }

    return SingleChildScrollView(
      child: Container(
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
              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _services.users.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> customersSnapshot) {
                  if (customersSnapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (!customersSnapshot.hasData ||
                      customersSnapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  int totalCustomers = getTotalCustomers(customersSnapshot);

                  return StreamBuilder<QuerySnapshot>(
                    stream: _services.vendors.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> vendorsSnapshot) {
                      if (vendorsSnapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (!vendorsSnapshot.hasData ||
                          vendorsSnapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }

                      int totalVendors = getTotalVendors(vendorsSnapshot);

                      return StreamBuilder<QuerySnapshot>(
                        stream: _services.products.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> productsSnapshot) {
                          if (productsSnapshot.hasError) {
                            return Center(child: Text('Something went wrong'));
                          }

                          if (!productsSnapshot.hasData ||
                              productsSnapshot.data == null) {
                            return Center();
                          }

                          int totalProducts =
                              getTotalProducts(productsSnapshot);
                          int featuredProducts =
                              getTotalFeaturedProducts(productsSnapshot);

                          return StreamBuilder<QuerySnapshot>(
                            stream: _services.orders.snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> ordersSnapshot) {
                              if (ordersSnapshot.hasError) {
                                return Center(
                                    child: Text('Something went wrong'));
                              }

                              if (!ordersSnapshot.hasData ||
                                  ordersSnapshot.data == null) {
                                return Center();
                              }

                              int totalOrders = getTotalOrders(ordersSnapshot);

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      generateBarChart(
                                          totalCustomers, totalVendors),
                                      generateBarChart2(
                                          totalProducts, totalOrders),
                                    ],
                                  ),
                                  SizedBox(height: 60),
                                  Align(
                                    alignment: Alignment.center,
                                    child: FractionallySizedBox(
                                      widthFactor:
                                          0.8, // Adjust this value to change the width of the row
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          generatePieChart(
                                              totalProducts, featuredProducts),
                                          _buildLegend(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerData {
  final String title;
  final int count;

  CustomerData({required this.title, required this.count});
}
