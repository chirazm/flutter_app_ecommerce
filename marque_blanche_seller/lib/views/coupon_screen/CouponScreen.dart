import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/services/store_services.dart';
import 'package:marque_blanche_seller/views/coupon_screen/add_coupon.dart';
import 'package:marque_blanche_seller/views/coupon_screen/add_edit_coupon_screen.dart';

import '../widgets/appbar_widget.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(coupons),
      body: StreamBuilder(
        stream: StoreServices.getCoupons(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No coupons added yet'),
            );
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: purpleColor),
                      onPressed: () {
                        var document;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEditCoupon(
                                      document: document,
                                    )));
                      },
                      child: const Text(
                        'Add New Coupon',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              FittedBox(
                child: DataTable(columns: const <DataColumn>[
                  DataColumn(
                    label: Text("Title"),
                  ),
                  DataColumn(
                    label: Text("Rate"),
                  ),
                  DataColumn(
                    label: Text("Status"),
                  ),
                  DataColumn(
                    label: Text("Expiry"),
                  ),
                  DataColumn(
                    label: Text("Info"),
                  ),
                ], rows: _couponList(snapshot.data, context)),
              )
            ],
          );
        },
      ),
    );
  }

  List<DataRow> _couponList(QuerySnapshot snapshot, context) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      var date = (document.data() as dynamic)['expiry'];
      var expiry = DateFormat.yMMMd().add_jm().format(date.toDate());
      return DataRow(cells: [
        DataCell(
          Text((document.data() as dynamic)['title'] ?? 'ok'),
        ),
        DataCell(
          Text((document.data() as dynamic)['discountRate'].toString()),
        ),
        DataCell(
          Text((document.data() as dynamic)['active'] ? 'Active' : 'Inactive'),
        ),
        DataCell(
          Text(expiry.toString()),
        ),
        DataCell(
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditCoupon(document: document)));
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ),
      ]);
    }).toList();
    return newList;
  }
}
