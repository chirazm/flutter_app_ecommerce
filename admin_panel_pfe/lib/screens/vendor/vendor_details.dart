import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:admin_panel_pfe/consts/style.dart';
import 'package:admin_panel_pfe/services/firebase_service.dart';
import 'package:admin_panel_pfe/screens/vendor/vendor_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorDetailsBox extends StatefulWidget {
  final String id;
  VendorDetailsBox(this.id);

  @override
  State<VendorDetailsBox> createState() => _VendorDetailsBoxState();
}

class _VendorDetailsBoxState extends State<VendorDetailsBox> {
  FirebaseServices _services = FirebaseServices();
  late TextEditingController _shopNameController;
  late TextEditingController _shopDescController;
  late TextEditingController _shopMobileController;
  late TextEditingController _emailController;
  late TextEditingController _shopAddressController;
  late TextEditingController _vendorNameController;

  int _totalOrders = 0;
  int _totalProducts = 0;
  bool _isLoading = true;
  int _totalRevenue = 0;
  int _totalFeaturedProducts = 0;
  @override
  void initState() {
    super.initState();
    _shopNameController = TextEditingController();
    _shopDescController = TextEditingController();
    _shopMobileController = TextEditingController();
    _emailController = TextEditingController();
    _shopAddressController = TextEditingController();
    _vendorNameController = TextEditingController();

    _updateVendor(widget.id);
    _fetchTotalOrders(widget.id);
    _fetchTotalProducts(widget.id);
    _fetchTotalRevenue(widget.id);
    _fetchTotalFeaturedProducts(widget.id);
  }

  void _updateVendor(String vendorId) {
    _services.vendors.doc(widget.id).get().then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        _shopNameController.text = (data as dynamic)['shop_name'];
        _vendorNameController.text = (data as dynamic)['vendor_name'];

        _shopDescController.text = (data as dynamic)['shop_desc'];
        _shopMobileController.text = (data as dynamic)['shop_mobile'];
        _emailController.text = (data as dynamic)['email'];
        _shopAddressController.text = (data as dynamic)['shop_address'];
      }
    });
  }

  void _fetchTotalOrders(String vendorId) {
    _services.orders.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        var orders = (doc.data() as dynamic)['orders'];
        for (var item in orders) {
          if (item['vendor_id'] == vendorId) {
            setState(() {
              _totalOrders++;
            });
          }
        }
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _fetchTotalProducts(String vendorId) {
    _services.products
        .where('vendor_id', isEqualTo: vendorId)
        .get()
        .then((snapshot) {
      setState(() {
        _totalProducts = snapshot.docs.length;
      });
    });
  }

  void _fetchTotalRevenue(String vendorId) {
    _services.orders.get().then((snapshot) {
      int totalRevenue = 0;
      for (var doc in snapshot.docs) {
        var orders = (doc.data() as dynamic)['orders'];
        for (var item in orders) {
          if (item['vendor_id'] == vendorId) {
            totalRevenue += item['tprice'] as int;
          }
        }
      }
      setState(() {
        _totalRevenue = totalRevenue;
      });
    });
  }

  void _fetchTotalFeaturedProducts(String vendorId) {
    _services.products
        .where('vendor_id', isEqualTo: vendorId)
        .where('is_featured', isEqualTo: true)
        .get()
        .then((snapshot) {
      setState(() {
        _totalFeaturedProducts = snapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _services.vendors.doc(widget.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('Vendor data not found');
        }

        //var documentData = snapshot.data!.data();
        var documentId = snapshot.data!.id;

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 420,
              height: 700,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * .3,
                    child: ListView(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                snapshot.data!['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!['shop_name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(snapshot.data!['shop_mobile'])
                            ],
                          )
                        ],
                      ),
                      Divider(
                        thickness: 4,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    'Vendor Name',
                                    style: VendorDetailsBoxTextStyle,
                                  ),
                                )),
                                Container(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(':')),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Text(snapshot.data!['vendor_name']),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    'Email',
                                    style: VendorDetailsBoxTextStyle,
                                  ),
                                )),
                                Container(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(':')),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Text(snapshot.data!['email']),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    'Address',
                                    style: VendorDetailsBoxTextStyle,
                                  ),
                                )),
                                Container(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(':')),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Text(snapshot.data!['shop_address']),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    'Description',
                                    style: VendorDetailsBoxTextStyle,
                                  ),
                                )),
                                Container(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(':')),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Text(snapshot.data!['shop_desc']),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    'Account Status',
                                    style: VendorDetailsBoxTextStyle,
                                  ),
                                )),
                                Container(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        right: 10,
                                        top: 10,
                                      ),
                                      child: Text(':')),
                                ),
                                Expanded(
                                  child: Container(
                                    child: snapshot.data!['account_verified']
                                        ? Chip(
                                            backgroundColor: Colors.green,
                                            label: Row(
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  'Verified',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Chip(
                                            backgroundColor: Colors.red,
                                            label: Row(
                                              children: [
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  'Inactive',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Wrap(
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons
                                                .money_dollar_circle_fill,
                                            size: 40,
                                            color: Colors.black54,
                                          ),
                                          Text('Total Revenue'),
                                          Text(_totalRevenue.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons.cart_fill,
                                            size: 40,
                                            color: Colors.black54,
                                          ),
                                          Text('Featured \nProducts'),
                                          Text(
                                              _totalFeaturedProducts.toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart,
                                            size: 40,
                                            color: Colors.black54,
                                          ),
                                          Text('Total Orders'),
                                          Text(_totalOrders.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.grade_outlined,
                                            size: 40,
                                            color: Colors.black54,
                                          ),
                                          Text('Poducts'),
                                          Text(_totalProducts.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        _services.confirmDeleteDialogVendor(
                          context: context,
                          message: 'Are you sure you want to delete ?',
                          title: 'Delete Vendor',
                          id: documentId,
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 110,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => VendorEdit(documentId),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
