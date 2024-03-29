import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference banners =
      FirebaseFirestore.instance.collection('banners');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference category =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference users = FirebaseFirestore.instance.collection('user');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Future<QuerySnapshot> getAdminCredentials() {
    var result = FirebaseFirestore.instance.collection('admin').get();
    return result;
  }

  deleteBannerImageFromFirebase(id) async {
    banners.doc(id).delete();
  }

  updateVendorStatus({id, status}) async {
    vendors.doc(id).update({'account_verified': status ? false : true});
  }

  Future<void> confirmDeleteDialog({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteBannerImageFromFirebase(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog({title, message, context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteCategoryFromFirebase(id) async {
    category.doc(id).delete();
  }

  Future<void> confirmDeleteDialogCategory(
      {title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteCategoryFromFirebase(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteVendorFromFirebase(id) async {
    vendors.doc(id).delete();
  }

  Future<void> confirmDeleteDialogVendor({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteVendorFromFirebase(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCustomerFromFirebase(String customerId) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(customerId)
        .delete();
  }

  Future<void> confirmDeleteDialogCustomer(
      {title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteCustomerFromFirebase(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
