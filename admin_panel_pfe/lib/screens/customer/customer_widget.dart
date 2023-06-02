import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:admin_panel_pfe/services/firebase_service.dart';
import 'package:admin_panel_pfe/screens/vendor/vendor_details.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomerWidget extends StatefulWidget {
  @override
  State<CustomerWidget> createState() => _CustomerWidgetState();
}

class _CustomerWidgetState extends State<CustomerWidget> {
  FirebaseServices _services = FirebaseServices();
  int tag = 0;
  var searchController = TextEditingController();
  List<DocumentSnapshot> filteredCustomers = [];
  QuerySnapshot? customersSnapshot;

  List<String> options = [
    'All Customers',
    'Active Customers',
    'Inactive Customers',
  ];
  bool? active;
  void filter(int val) {
    setState(() {
      tag = val;
      if (val == 1) {
        active = true;
      } else if (val == 2) {
        active = false;
      } else {
        active = null;
      }
      _searchCustomers(searchController.text);
    });
  }

  void _deleteCustomer(String customerId) {
    _services.deleteCustomerFromFirebase(
        customerId); // Supprimer le client de la base de données Firebase
    setState(() {
      filteredCustomers.removeWhere((customer) => customer.id == customerId);
    });
  }

  void _searchCustomers(String query) {
    filteredCustomers.clear(); // Clear the previous filtered customers

    if (query.isEmpty) {
      filteredCustomers.addAll(customersSnapshot!.docs);
    } else {
      for (var customer in customersSnapshot!.docs) {
        String customerName =
            (customer.data() as dynamic)['name'].toString().toLowerCase();
        if (customerName.contains(query.toLowerCase())) {
          filteredCustomers.add(customer);
        }
      }
    }
  }

  Future<void> _confirmDeleteDialogCustomer(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Customer'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteCustomer(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipsChoice<int>.single(
          value: tag,
          onChanged: (val) => filter(val),
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
                    filteredCustomers.clear();
                  });
                },
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchCustomers(value);
              });
            },
          ),
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _services.users
              .where('account_verified', isEqualTo: active)
              .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>?,
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
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

            customersSnapshot = snapshot.data; // Update the snapshot data

            if (filteredCustomers.isEmpty) {
              filteredCustomers.addAll(customersSnapshot!.docs);
            }

            if (filteredCustomers.isEmpty) {
              return Text('No users found with the entered name.');
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 180.0,
                showBottomBorder: true,
                dataRowHeight: 100,
                headingTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                headingRowColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 114, 114, 114)),
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('Customer Image'),
                  ),
                  DataColumn(
                    label: Text('Customer Name'),
                  ),
                  DataColumn(
                    label: Text('Email'),
                  ),
                  DataColumn(
                    label: Text('Delete Customer'),
                  ),
                ],
                rows: _customersDetailsRows(filteredCustomers, _services),
              ),
            );
          },
        ),
      ],
    );
  }

  List<DataRow> _customersDetailsRows(
    List<DocumentSnapshot> customers,
    FirebaseServices services,
  ) {
    List<DataRow> newList = customers.map((DocumentSnapshot document) {
      String imageUrl = (document.data() as dynamic)['imageUrl'];
      var documentId = document.id;

      if (imageUrl.isEmpty) {
        imageUrl = 'assets/images/profile_picture.png';
      }
      return DataRow(cells: [
        DataCell(
          Image.network(
            imageUrl,
            width: 100,
          ),
        ),
        DataCell(
          Text((document.data() as dynamic)['name']),
        ),
        DataCell(
          Text((document.data() as dynamic)['email']),
        ),
        DataCell(IconButton(
          icon: Icon(
            Icons.delete,
            color: buttonColor,
          ),
          onPressed: () {
            _confirmDeleteDialogCustomer(documentId);
          },
        )),
      ]);
    }).toList();
    return newList;
  }
}
