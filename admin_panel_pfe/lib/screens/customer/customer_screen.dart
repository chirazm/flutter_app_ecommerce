import 'package:admin_panel_pfe/screens/customer/customer_widget.dart';
import 'package:admin_panel_pfe/screens/vendor/vendor_add.dart';
import 'package:admin_panel_pfe/screens/vendor/vendor_filter_widget.dart';
import 'package:admin_panel_pfe/screens/vendor/vendor_widget.dart';
import 'package:flutter/material.dart';

class CustomersScreen extends StatelessWidget {
  static const String routeName = "\CustomersScreen";

  Widget rowHeader(String text, int flex) {
    return Expanded(
        child: Container(
      child: Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: Colors.yellow.shade900,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Customers',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Manage all the customers activities',
                  ),
                  SizedBox(
                    width: 770,
                  ),
                ],
              ),
              Divider(
                thickness: 5,
              ),
              CustomerWidget(),
              Divider(
                thickness: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
