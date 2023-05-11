import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';

class CouponController with ChangeNotifier {
  late bool expired;
  late final DocumentSnapshot document;
  int discountRate = 0;
  Future<DocumentSnapshot> getCouponDetails(title, vendorId) async {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('coupons').doc(title).get();

    if (document.exists) {
      if (((document.data() as dynamic)['vendor_id']) == vendorId) {
        checkExpiry(document);
      }
    }
    return document;
  }

  checkExpiry(DocumentSnapshot document) {
    DateTime date = (document.data() as dynamic)['expiry'].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if (dateDiff < 0) {
      expired = true;
      notifyListeners();
    } else {
      this.document = document;
      expired = false;
      discountRate = (document.data() as dynamic)['discountRate'];
      notifyListeners();
    }
  }
}
