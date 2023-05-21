import 'dart:io';

import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:admin_panel_pfe/consts/style.dart';
import 'package:admin_panel_pfe/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorEdit extends StatefulWidget {
  final String id;

  VendorEdit(this.id);

  @override
  State<VendorEdit> createState() => _VendorEditState();
}

class _VendorEditState extends State<VendorEdit> {
  FirebaseServices _services = FirebaseServices();
  late TextEditingController _shopNameController;
  late TextEditingController _shopDescController;
  late TextEditingController _shopMobileController;
  late TextEditingController _emailController;
  late TextEditingController _shopAddressController;
  late TextEditingController _vendorNameController;
  String? _imageUrl;
  late File? _image = null;
  String _successMessage = '';
  String? _shopMobileError;

  @override
  void initState() {
    super.initState();
    _shopNameController = TextEditingController();
    _shopDescController = TextEditingController();
    _shopMobileController = TextEditingController();
    _emailController = TextEditingController();
    _shopAddressController = TextEditingController();
    _vendorNameController = TextEditingController();

    // Fetch the vendor's details and populate the text fields
    _services.vendors.doc(widget.id).get().then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        _shopNameController.text = (data as dynamic)['shop_name'];
        _vendorNameController.text = (data as dynamic)['vendor_name'];
        _shopDescController.text = (data as dynamic)['shop_desc'];
        _shopMobileController.text = (data as dynamic)['shop_mobile'];
        _emailController.text = (data as dynamic)['email'];
        _shopAddressController.text = (data as dynamic)['shop_address'];
        setState(() {
          _imageUrl = data['imageUrl'];
        });
      }
    });
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _vendorNameController.dispose();
    _shopDescController.dispose();
    _shopMobileController.dispose();
    _emailController.dispose();
    _shopAddressController.dispose();
    super.dispose();
  }

  bool _validateShopMobile() {
    if (_shopMobileController.text.length != 8) {
      setState(() {
        _shopMobileError = 'Phone number must be 8 digits';
      });
      return false;
    } else {
      setState(() {
        _shopMobileError = null;
      });
      return true;
    }
  }

  void _updateVendorProfile() {
    if (!_validateShopMobile()) {
      return;
    }
    try {
      _services.vendors.doc(widget.id).update({
        'shop_name': _shopNameController.text,
        'vendor_name': _vendorNameController.text,
        'shop_desc': _shopDescController.text,
        'shop_mobile': _shopMobileController.text,
        'email': _emailController.text,
        'shop_address': _shopAddressController.text,
      }).then((value) {
        setState(() {
          _successMessage = 'Profile updated successfully';
        });
        Navigator.pop(context);
      }).catchError((error) {
        setState(() {
          _successMessage = 'Failed to update profile';
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: SizedBox(
            width: 450,
            height: 700,
            child: Stack(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Edit Vendor Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: buttonColor,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : _imageUrl != null
                                    ? NetworkImage(_imageUrl!)
                                    : NetworkImage(
                                        'https://via.placeholder.com/150',
                                      ) as ImageProvider<Object>,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _shopNameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.add_business,
                              color: appbarColor,
                            ),
                            labelText: 'Shop Name',
                            labelStyle:
                                TextStyle(color: appbarColor, fontSize: 14),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusColor: Color.fromARGB(255, 213, 10, 231),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _vendorNameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_2_outlined,
                              color: appbarColor,
                            ),
                            labelText: 'Vendor Name',
                            labelStyle:
                                TextStyle(color: appbarColor, fontSize: 14),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusColor: Color.fromARGB(255, 213, 10, 231),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _shopMobileError =
                                  null; // Clear the error message when typing
                            });
                          },
                          controller: _shopMobileController,
                          decoration: InputDecoration(
                            errorText: _shopMobileError,
                            prefixIcon: Icon(
                              Icons.phone_android_outlined,
                              color: appbarColor,
                            ),
                            labelText: 'Contact Number',
                            labelStyle:
                                TextStyle(color: appbarColor, fontSize: 14),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusColor: Color.fromARGB(255, 213, 10, 231),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: appbarColor,
                            ),
                            labelText: 'Email',
                            labelStyle:
                                TextStyle(color: appbarColor, fontSize: 14),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusColor: Color.fromARGB(255, 213, 10, 231),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _shopAddressController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: appbarColor,
                            ),
                            labelText: 'Shop Address',
                            labelStyle:
                                TextStyle(color: appbarColor, fontSize: 14),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusColor: Color.fromARGB(255, 213, 10, 231),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _shopDescController,
                            maxLines: null,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.description_outlined,
                                color: appbarColor,
                              ),
                              labelText: 'Shop Description',
                              labelStyle:
                                  TextStyle(color: appbarColor, fontSize: 14),
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusColor: Color.fromARGB(255, 213, 10, 231),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _updateVendorProfile,
                              child: Text('Save'),
                              style: ElevatedButton.styleFrom(
                                primary: buttonColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: _successMessage.isNotEmpty,
                          child: Text(
                            _successMessage,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
