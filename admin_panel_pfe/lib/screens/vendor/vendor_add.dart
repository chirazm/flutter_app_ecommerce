import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddVendorWidget extends StatefulWidget {
  @override
  State<AddVendorWidget> createState() => _AddVendorWidgetState();
}

class _AddVendorWidgetState extends State<AddVendorWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic _image;

  String? fileName;
  late String shopName;
  late String shopDesc;
  late String email;
  late String password;
  late String shopAddress;
  late String shopMobile;
  late String vendorName;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _imageAdded = false;

  bool? accountStatus = false;
  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
        _imageAdded = true;
      });
    }
  }

  _uploadVendorToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('vendorImages').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVendor() async {
    try {
      EasyLoading.show();
      if (!_imageAdded) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Alert"),
            content: Text("Please add an image before registering."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Ok"),
              ),
            ],
          ),
        );
        return;
      } else if (_formKey.currentState!.validate()) {
        String imageUrl = await _uploadVendorToStorage(_image);
        await _firestore.collection('vendors').doc(fileName).set({
          'imageUrl': imageUrl,
          'shop_name': shopName,
          'shop_desc': shopDesc,
          'id': fileName,
          'account_verified': accountStatus,
          'email': email,
          'password': password,
          'shop_address': shopAddress,
          'shop_mobile': shopMobile,
          'vendor_name': vendorName,
        }).whenComplete(() {
          EasyLoading.dismiss();
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Alert "),
              content: Text("Vendor added successfully!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Ok"),
                ),
              ],
            ),
          ).then((_) {
            Navigator.of(context).pop();
          });
          setState(() {
            _image = null;
            _formKey.currentState!.reset();
          });
        });
      } else {
        print('Form validation failed');
      }
    } catch (e) {
      EasyLoading.dismiss();
      Text("Image is empty");
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SizedBox(
            width: 450,
            height: 900,
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
                                  border:
                                      Border.all(color: Colors.grey.shade800),
                                  borderRadius: BorderRadius.circular(10)),
                              child: _image != null
                                  ? Image.memory(
                                      _image,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Text('Shop Image'),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          width: 180,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: buttonColor,
                            ),
                            onPressed: () {
                              if (_image == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Image is empty'),
                                      content: Text(
                                          'Please add an image before registering.'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              _pickImage();
                            },
                            child: Text('Upload Image'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  Container(),
                  TextFormField(
                    onChanged: (value) {
                      shopName = value;
                    },
                    validator: (value) {
                      if (_autovalidateMode != AutovalidateMode.disabled &&
                          (value == null ||
                              value.isEmpty ||
                              value.length < 8)) {
                        return 'Shop Name must be at least 8 characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.add_business,
                        color: appbarColor,
                      ),
                      labelText: 'Shop Name',
                      labelStyle: TextStyle(color: appbarColor, fontSize: 14),
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
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      vendorName = value;
                    },
                    validator: (value) {
                      if (_autovalidateMode != AutovalidateMode.disabled &&
                          (value == null ||
                              value.isEmpty ||
                              value.length < 8)) {
                        return 'Vendor Name must be at least 8 characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_2_outlined,
                        color: appbarColor,
                      ),
                      labelText: 'Vendor Name',
                      labelStyle: TextStyle(color: appbarColor, fontSize: 14),
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
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      shopMobile = value;
                    },
                    validator: (value) {
                      if (_autovalidateMode != AutovalidateMode.disabled &&
                          (value == null ||
                              value.isEmpty ||
                              value.length != 8)) {
                        return 'Phone number must be 8 digits';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_android_outlined,
                        color: appbarColor,
                      ),
                      labelText: 'Contact Number',
                      labelStyle: TextStyle(color: appbarColor, fontSize: 14),
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
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (_autovalidateMode != AutovalidateMode.disabled &&
                          (value == null ||
                              value.isEmpty ||
                              !value.contains('@'))) {
                        return 'Invalid email address, please an ';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: appbarColor,
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: appbarColor, fontSize: 14),
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
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      shopAddress = value;
                    },
                    validator: (value) {
                      if (_autovalidateMode != AutovalidateMode.disabled &&
                          (value!.isEmpty)) {
                        return 'Enter Shop Address ';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: appbarColor,
                      ),
                      labelText: 'Shop Address ',
                      labelStyle: TextStyle(color: appbarColor, fontSize: 14),
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
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (_autovalidateMode != AutovalidateMode.disabled &&
                          (value == null ||
                              value.isEmpty ||
                              value.length < 8 ||
                              !value.contains(RegExp(r'\d')) ||
                              !value.contains(RegExp(r'[a-zA-Z]')))) {
                        return 'Password must be at least 8 characters and contain both letters and numbers';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.password_outlined,
                        color: appbarColor,
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: appbarColor, fontSize: 14),
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
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    maxLines: null,
                    onChanged: (value) {
                      shopDesc = value;
                    },
                    validator: (value) {
                      if (_autovalidateMode != AutovalidateMode.disabled &&
                          (value!.isEmpty)) {
                        return 'Enter Shop Description ';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.description_outlined,
                        color: appbarColor,
                      ),
                      labelText: 'Shop Description',
                      labelStyle: TextStyle(color: appbarColor, fontSize: 14),
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
                  SizedBox(
                    height: 5,
                  ),
                  CheckboxListTile(
                    value: accountStatus,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        accountStatus = value;
                      });
                    },
                    title: Text(
                      "This account is verified ? Please Check the Box.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: buttonColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _autovalidateMode = AutovalidateMode.onUserInteraction;
                      });
                      uploadVendor();
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
