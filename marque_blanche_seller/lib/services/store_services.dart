import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marque_blanche_seller/const/const.dart';

class StoreServices {
  static Future<DocumentSnapshot> getProfile(String userId) async {
    final DocumentSnapshot profileDoc = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(userId)
        .get();

    return profileDoc;
  }

  static getMessages(uid) {
    return firestore
        .collection(chatsCollection)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }

  static getOrders(uid) {
    return firestore
        .collection(ordersCollection)
        .where('vendors', arrayContains: uid)
        .snapshots();
  }

  static Stream<QuerySnapshot> searchOrdersByName(String buyerName) {
    return firestore.collection(ordersCollection).snapshots();
  }

  static Stream<QuerySnapshot> searchProductsByNameForUser(String productName, String currentUserId) {
  return FirebaseFirestore.instance
      .collection('products')
      .where('vendor_id', isEqualTo: currentUserId)
      .where('p_name', isGreaterThanOrEqualTo: productName)
      .where('p_name', isLessThan: productName + 'z')
      .snapshots();
}

  static getProducts(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  static getCoupons(uid) {
    return firestore
        .collection(couponsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }
}
