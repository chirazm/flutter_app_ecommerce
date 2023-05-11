import 'package:admin_panel_pfe/widgets/vendor/vendor_add.dart';
import 'package:admin_panel_pfe/widgets/vendor/vendor_filter_widget.dart';
import 'package:admin_panel_pfe/widgets/vendor/vendor_widget.dart';
import 'package:flutter/material.dart';

class VendorsScreen extends StatelessWidget {
  static const String routeName = "\VendorsScreen";

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
                'Manage Vendors',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Manage all the vendors activities',
                  ),
                  SizedBox(
                    width: 770,
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddVendorWidget();
                          });
                    },
                    child: Text("Add new Vendor"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Color.fromARGB(255, 213, 10, 231),
                      textStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 5,
              ),
              VendorWidget(),
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
