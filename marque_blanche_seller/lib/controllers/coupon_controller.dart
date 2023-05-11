import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';

class CouponController extends GetxController {
  var isloading = false;
  saveCoupon(
      {context, document, title, active, discountRate, expiry, details}) async {
    var store = firestore.collection(couponsCollection).doc();
    if (document == null) {
      await store.set({
        'title ': title,
        'discountRate': discountRate,
        'expiry': expiry,
        'details': details,
        'active': active,
        'vendor_id': currentUser!.uid,
      });
    }
    await store.update({
      'title ': title,
      'discountRate': discountRate,
      'expiry': expiry,
      'details': details,
      'active': active,
      'vendor_id': currentUser!.uid,
    });
  }
}
