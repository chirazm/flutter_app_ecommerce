import 'dart:html';

import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:admin_panel_pfe/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {
  static const String id = 'banner_screen';

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _bannersStream =
        FirebaseFirestore.instance.collection('banners').snapshots();
    FirebaseServices _services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: _bannersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
            ),
          );
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: GridView.builder(
            //scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 15, crossAxisSpacing: 15),
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              final bannerData = snapshot.data!.docs[index];

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Card(
                        child: Image.network(
                          bannerData['image'],
                          width: 300,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                              onPressed: () {
                                _services.confirmDeleteDialog(
                                  context: context,
                                  message: 'Are you sure you want to delete ?',
                                  title: 'Delete Banner',
                                  id: snapshot.data!.docs[index].reference.id,
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: buttonColor,
                              )),
                        ))
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
