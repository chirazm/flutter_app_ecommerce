import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pfe_app/consts/colors.dart';

class SellerContactScreen extends StatelessWidget {
  final String sellerId;

  const SellerContactScreen({required this.sellerId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('vendors').doc(sellerId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Seller not found'));
        }

        final sellerData = snapshot.data!;
        final email = sellerData.get('email') ?? '';
        final phoneNumber = sellerData.get('shop_mobile') ?? '';

        return Scaffold(
          backgroundColor: lightGrey,
          appBar: AppBar(
            title: "Seller Contact"
                .text
                .fontFamily(semibold)
                .color(darkFontGrey)
                .make(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 30,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        final Uri _emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: email,
                        );
                        launch(_emailLaunchUri.toString());
                      },
                      child: Row(
                        children: [
                          const Text(
                            'Email : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$email',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: Colors.green,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        final Uri _phoneLaunchUri = Uri(
                          scheme: 'tel',
                          path: phoneNumber,
                        );
                        launch(_phoneLaunchUri.toString());
                      },
                      child: Row(
                        children: [
                          const Text(
                            'Phone Number : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$phoneNumber',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
