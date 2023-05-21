import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/views/cart_screen/coupn.dart';

class FirestoreServices {
  //get users data
  static getUser(uid) {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //get products according to category
  static getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  //
  static getSubCategoryProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: title)
        .snapshots();
  }

  static updateDocument(String documentId, Map<String, dynamic> data) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection(cartCollection).doc(documentId);

    await documentReference
        .update(data)
        .then((value) => print("Document Updated"))
        .catchError((error) => print("Failed to update document: $error"));
  }

  static getCategoriesName(name) {
    return firestore
        .collection(categoriesCollection)
        .where('name', isEqualTo: name)
        .snapshots();
  }
  static Future<List<Coupon>> getCoupons() async {
    final couponsSnapshot = await FirebaseFirestore.instance
        .collection('coupons')
        .get();

    final List<Coupon> coupons = [];

    couponsSnapshot.docs.forEach((doc) {
      final coupon = Coupon(
        id: doc.id,
        title: doc.data()['title'] ?? '',
        details: doc.data()['details'] ?? '',
        active: doc.data()['active'] ?? false,
        expiry: (doc.data()['expiry'] as Timestamp).toDate(),
        discountRate: doc.data()['discountRate']?.toDouble() ?? 0.0,
      );

      coupons.add(coupon);
    });

    return coupons;
  }

  //get cart
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where("added_by", isEqualTo: uid)
        .snapshots();
  }

  //delete document
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  //get all chat messages
  static getChatMessages(docId) {
    return firestore
        .collection(chatCollection)
        .doc(docId)
        .collection(messageCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getWishlists() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getAllMessages() {
    return firestore
        .collection(chatCollection)
        .where('fromId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getCategories() {
    return firestore.collection(categoriesCollection).get();
  }

//get count of wishlist, orders and cart
  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productsCollection)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }

  static allProducts() {
    return firestore.collection(productsCollection).snapshots();
  }

//get featured products method
  static getfeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  static searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }

  //get banners
}
