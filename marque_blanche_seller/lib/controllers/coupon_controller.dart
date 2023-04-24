import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';

class CouponController extends GetxController {
  var isloading = false; 
  saveCoupon({context, title, active, discountRate, expiry, details}) async {
    var store = firestore.collection(couponsCollection).doc();
    await store.set({
      'title ': title,
      'discountRate': discountRate,
      'expiry': expiry,
      'details': details,
      'active': active,
      'seller': currentUser!.uid,
    });
  }
}
