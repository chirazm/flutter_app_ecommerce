import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:admin_panel_pfe/widgets/vendor/ShopPicCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddVendorWidget extends StatefulWidget {
  const AddVendorWidget({super.key});

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
    EasyLoading.show();
    if (_formKey.currentState!.validate()) {
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
            title: Text("Show Alert Dialog Box"),
            content: Text("You have raised a Alert Dialog Box"),
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
        setState(() {
          _image = null;
          _formKey.currentState!.reset();
        });
      });
    } else {
      print('Upload failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          width: 450,
          height: 900,
          child: Form(
            key: _formKey,
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
                                border: Border.all(color: Colors.grey.shade800),
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
                    if (value!.isEmpty) {
                      return 'Enter Shop Name ';
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
                    shopMobile = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Mobile Number  ';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone_android_outlined,
                      color: appbarColor,
                    ),
                    labelText: 'Mobile Number',
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
                    if (value!.isEmpty) {
                      return 'Enter Email ';
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
                    if (value!.isEmpty) {
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
                    if (value!.isEmpty) {
                      return 'Enter Password ';
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
                  onChanged: (value) {
                    vendorName = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Vendor Name ';
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
                  onChanged: (value) {
                    shopDesc = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
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
                    "This account is verified ? Please CheckBox.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: buttonColor,
                  ),
                  onPressed: () {
                    uploadVendor();
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
