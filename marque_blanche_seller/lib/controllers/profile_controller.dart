import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../const/const.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;
  var profileImgPath = ''.obs;
  var profileImageLink = '';
  var isloading = false.obs;
  var shopName = ''.obs;
  var shopAddress = ''.obs;
  var shopMobile = ''.obs;
  var shopDesc = ''.obs;

  //textfield
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  //shop controllers
  var shopNameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopWebsiteController = TextEditingController();
  var shopDescController = TextEditingController();
  late Rx<Map<String, dynamic>> snapshotDataa;

  void setSnapshotData(Map<String, dynamic> data) {
    snapshotData = data.obs as QueryDocumentSnapshot<Object?>;
  }

  void getDataFromSnapshot(QueryDocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    setSnapshotData(data);
  }

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({name, password, imageUrl}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set(
        {'vendor_name': name, 'password': password, 'imageUrl': imageUrl},
        SetOptions(merge: true));
    isloading(false);
  }

  Future<void> fetchShopData() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      var shopData = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(currentUserId)
          .get();

      shopNameController.text = shopData['shop_name'];
      shopAddressController.text = shopData['shop_address'];
      shopMobileController.text = shopData['shop_mobile'];
      shopDescController.text = shopData['shop_desc'];
    } catch (error) {
      print('Error fetching shop data: $error');
    }
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      print(error.toString());
    });
  }

  updateShop({shopname, shopaddress, shopmobile, shopdesc}) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    var store = FirebaseFirestore.instance
        .collection(vendorsCollection)
        .doc(currentUserId);
    await store.update({
      'shop_name': shopname,
      'shop_address': shopaddress,
      'shop_mobile': shopmobile,
      'shop_desc': shopdesc,
    }).then((value) {
      shopName.value = shopname;
      shopAddress.value = shopaddress;
      shopMobile.value = shopmobile;
      shopDesc.value = shopdesc;
      isloading(false);
    }).catchError((error) {
      print('Error updating shop data: $error');
    });
  }
}
