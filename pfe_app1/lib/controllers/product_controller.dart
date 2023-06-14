import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/models/category_model.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var subcat = [];
  var colorIndex = 0.obs;
  RxInt totalPrice = RxInt(0);
  var isFav = false.obs;
  RxString selectedSubcategory = RxString('');

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  void calculateTotalPrice(double price, double? discountedPrice,
      double oldPrice, bool isFlashSaleExpired) {
    if (discountedPrice != null &&
        discountedPrice != 0.0 &&
        !isFlashSaleExpired) {
      totalPrice.value = (discountedPrice * quantity.value).toInt();
    } else {
      totalPrice.value = (oldPrice * quantity.value).toInt();
    }

    if (isFlashSaleExpired) {
      discountedPrice = null;
    }
  }

  void selectSubcategory(String subcategory) {
    selectedSubcategory.value = subcategory;
  }

  addToCart(
      {title,
      imageURL,
      sellername,
      color,
      qty,
      tprice,
      context,
      vendorID}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': imageURL,
      'sellername': sellername,
      //'color': color,
      'qty': qty,
      'vendor_id': vendorID,
      'tprice': tprice,
      'added_by': currentUser!.uid
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  updateCartItemQuantity(docId, int newQuantity) async {
    await FirebaseFirestore.instance.collection('cart').doc(docId).update({
      'qty': newQuantity,
    });
  }

  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
    isFav.value = false;
  }

  resetQuantity() {
    quantity.value = 0;
  }

  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  removeFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }

  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
