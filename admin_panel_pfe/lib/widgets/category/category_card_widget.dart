import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:admin_panel_pfe/widgets/category/subcategory_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/firebase_service.dart';

class CategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categorysStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    FirebaseServices _services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: _categorysStream,
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
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, mainAxisSpacing: 12, crossAxisSpacing: 5),
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              final categoriesData = snapshot.data!.docs[index];

              return  InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SubCategoryWidget(categoriesData['name']);
            });
      },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 190, 188, 188),
                          border: Border.all(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(8)),
                      child: SizedBox(
                          height: 300,
                          width: 180,
                          child: Card(
                              color: Color.fromARGB(255, 252, 184, 210),
                              elevation: 4,
                              child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 90,
                                          width: double.infinity,
                                          child: Image.network(
                                              categoriesData['image']),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              categoriesData['name'],
                                              style: TextStyle(fontSize: 16),
                                            )),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: IconButton(
                                            onPressed: () {
                                              _services
                                                  .confirmDeleteDialogCategory(
                                                context: context,
                                                message:
                                                    'Are you sure you want to delete ?',
                                                title: 'Delete Category',
                                                id: snapshot.data!.docs[index]
                                                    .reference.id,
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: buttonColor,
                                            ),
                                          ),
                                        )
                                      ])))),
                    )
                  ]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
