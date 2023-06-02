import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/controllers/home_controller.dart';

import '../models/category_model.dart';
import 'package:path/path.dart';

class ProductsController extends GetxController {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  var isloading = false.obs;
  //text field controllers
  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pdiscountController = TextEditingController();

  var pquantityController = TextEditingController();

  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  List<Category> category = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);

  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectedColorIndex = 0.obs;
  var searchController = TextEditingController();

  getCategories() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();
    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubCategory(cat) {
    subcategoryList.clear();
    var data = category.where((element) => element.name == cat).toList();
    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImages() async {
    pImagesLinks.clear();
    for (var item in pImagesList) {
      if (item != null) {
        var filename = basename(item.path);
        var destination = 'images/vendors/${currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks.add(n);
      }
    }
  }

  uploadProduct(context) async {
    var store = firestore.collection(productsCollection).doc();
    String productId = store.id;
    await store.set({
      'id': productId,
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_colors': FieldValue.arrayUnion([
        Colors.red.value,
        Colors.brown.value,
      ]),
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_seller': Get.find<HomeController>().username,
      'p_rating': "5.0",
      'vendor_id': currentUser!.uid,
      'featured_id': '',
      'discountedPrice': pdiscountController.text,
    });
    isloading(false);
    VxToast.show(context, msg: "Product uploaded");
  }

  void updateProduct({
    required BuildContext context,
    required String productName,
    required String description,
    required String price,
    required String category,
    required String subcategory,
    required String quantity,
    required String seller,
    required String productId,
    required List<String> image,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final productRef = firestore.collection('products').doc(productId);
      await productRef.update({
        'p_name': productName,
        'p_desc': description,
        'p_price': price,
        'p_category': category,
        'p_subcategory': subcategory,
        'p_quantity': quantity,
        'p_seller': seller,
        'p_imgs': image,
      });
      EasyLoading.showSuccess('Product Updated !');
    } catch (e) {
      EasyLoading.showError('Failed to update product.');
    }
  }

  addFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  removeProduct(docId) async {
    await firestore.collection(productsCollection).doc(docId).delete();
  }

  uploadImageToFirebaseStorage(File newImage) {}
}
