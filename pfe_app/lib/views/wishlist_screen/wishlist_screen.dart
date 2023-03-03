import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/services/firestore_services.dart';
import 'package:pfe_app/widget_common/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: whiteColor,

      appBar: AppBar(
          title: "My Wishlist"
              .text
              .color(darkFontGrey)
              .fontFamily(semibold)
              .make()),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No wishlist yet !".text.color(darkFontGrey).makeCentered();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
