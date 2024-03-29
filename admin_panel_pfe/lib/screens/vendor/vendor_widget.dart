import 'dart:html';

import 'package:admin_panel_pfe/services/firebase_service.dart';
import 'package:admin_panel_pfe/screens/vendor/vendor_details.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class VendorWidget extends StatefulWidget {
  @override
  State<VendorWidget> createState() => _VendorWidgetState();
}

class _VendorWidgetState extends State<VendorWidget> {
  List<DocumentSnapshot> filteredVendors = [];
  QuerySnapshot? customersSnapshot;
  var searchController = TextEditingController();

  int tag = 0;

  List<String> options = [
    'All vendors',
    'Active Vendors',
    'Inactive Vendors',
  ];
  bool? active;
  filter(val) {
    if (val == 1) {
      setState(() {
        active = true;
      });
    }
    if (val == 2) {
      setState(() {
        active = false;
      });
    }
    if (val == 0) {
      setState(() {
        active = null;
      });
    }
  }

  void _searchVendors(String query) {
    filteredVendors.clear(); // Clear the previous filtered customers

    if (query.isEmpty) {
      filteredVendors.addAll(customersSnapshot!.docs);
    } else {
      for (var vendor in customersSnapshot!.docs) {
        String vendorName =
            (vendor.data() as dynamic)['shop_name'].toString().toLowerCase();
        if (vendorName.contains(query.toLowerCase())) {
          filteredVendors.add(vendor);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipsChoice<int>.single(
          value: tag,
          onChanged: (val) {
            setState(() {
              tag = val;
            });
            filter(tag);
          },
          choiceItems: C2Choice.listFrom<int, String>(
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
          choiceCheckmark: true,
          choiceStyle: C2ChipStyle.filled(
            selectedStyle: const C2ChipStyle(
              backgroundColor: Color.fromARGB(115, 110, 107, 107),
            ),
          ),
        ),
        Divider(
          thickness: 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search by name...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    filteredVendors.clear();
                  });
                },
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchVendors(value);
              });
            },
          ),
        ),
        StreamBuilder(
          stream: _services.vendors
              .where('account_verified', isEqualTo: active)
              // .orderBy('shop_name', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.cyan,
                ),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 65.0,
                showBottomBorder: true,
                dataRowHeight: 100,
                headingTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                headingRowColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 114, 114, 114)),
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('Active / Inactive'),
                  ),
                  DataColumn(
                    label: Text('Shop Image'),
                  ),
                  DataColumn(
                    label: Text('Shop Name'),
                  ),
                  DataColumn(
                    label: Text('Shop Address'),
                  ),
                  DataColumn(
                    label: Text('Email'),
                  ),
                  DataColumn(
                    label: Text('Mobile'),
                  ),
                  DataColumn(
                    label: Text('View Details'),
                  ),
                ],
                rows: _vendorsDetailsRows(snapshot.data, _services),
              ),
            );
          },
        ),
      ],
    );
  }

  List<DataRow> _vendorsDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(
          IconButton(
            onPressed: () {
              services.updateVendorStatus(
                id: (document.data() as dynamic)['id'],
                status: (document.data() as dynamic)['account_verified'],
              );
            },
            icon: (document.data() as dynamic)['account_verified']
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
          ),
        ),
        DataCell(
          Container(
            width: 65,
            height: 65,
            child: Image.network(
              (document.data() as dynamic)['imageUrl'],
              width: 100,
            ),
          ),
        ),
        DataCell(
          Text((document.data() as dynamic)['shop_name']),
        ),
        DataCell(
          Text((document.data() as dynamic)['shop_address']),
        ),
        DataCell(
          Text((document.data() as dynamic)['email']),
        ),
        DataCell(
          Text((document.data() as dynamic)['shop_mobile']),
        ),
        DataCell(IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VendorDetailsBox((document.data() as dynamic)['id']);
                  });
            },
            icon: Icon(Icons.info_outline))),
      ]);
    }).toList();
    return newList;
  }
}
