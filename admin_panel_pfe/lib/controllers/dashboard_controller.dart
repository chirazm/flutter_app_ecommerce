 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

int getTotalCustomers(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
      return snapshot.data!.size;
    }

    int getTotalVendors(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
      return snapshot.data!.size;
    }

    int getTotalProducts(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
      return snapshot.data!.size;
    }

    int getTotalOrders(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
      return snapshot.data!.size;
    }

    int getTotalFeaturedProducts(
        AsyncSnapshot<QuerySnapshot> productsSnapshot) {
      int count = 0;
      if (productsSnapshot.hasData) {
        final products = productsSnapshot.data!.docs;
        for (var product in products) {
          if ((product.data() as dynamic)['is_featured'] == true) {
            count++;
          }
        }
      }
      return count;
    }