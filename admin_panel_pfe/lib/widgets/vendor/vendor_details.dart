import 'package:admin_panel_pfe/consts/style.dart';
import 'package:admin_panel_pfe/services/firebase_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 450,
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
                              Text(snapshot.data!['shop_desc'])
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
                                    'Contact Number',
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
                                  child: Text(snapshot.data!['shop_mobile']),
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
                                        : Container(),
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
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons
                                                .money_dollar_circle_fill,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Total Revenue'),
                                          Text('130.000')
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
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons.cart_fill,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Active Orders'),
                                          Text('0')
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
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Total Orders'),
                                          Text('30')
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
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.grade_outlined,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Poducts'),
                                          Text('130')
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
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.list_alt_outlined,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Statement'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ]),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
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
                                  style: TextStyle(color: Colors.white),
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
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
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
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.list_alt_outlined,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Block now'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                    Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Icon(Icons.block_)
                      ],
                    )
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
