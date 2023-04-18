import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pfe_app/consts/colors.dart';

class CounterForCard extends StatefulWidget {
  final DocumentSnapshot document;
  const CounterForCard(this.document, {super.key});
  @override
  State<CounterForCard> createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {
  User? user = FirebaseAuth.instance.currentUser;
  getCardData(productId) {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('products')
        .where('productId', isEqualTo: productId)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc['productId'] == productId) {
                  setState(() {
                    
                  });
                }
              })
            });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
          border: Border.all(color: redColor),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          // ignore: avoid_unnecessary_containers
          Container(
            // ignore: prefer_const_constructors
            child: Padding(
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: const Icon(
                Icons.remove,
                color: redColor,
              ),
            ),
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            // ignore: prefer_const_constructors
            height: double.infinity,
            width: 30,
            color: redColor,
            child: const Center(
                child: FittedBox(
                    child: Text(
              '1',
              style: TextStyle(color: whiteColor),
            ))),
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            // ignore: prefer_const_constructors
            child: Padding(
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: const Icon(
                Icons.add,
                color: redColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
