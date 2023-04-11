import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:admin_panel_pfe/widgets/category/subcategory_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final DocumentSnapshot document;
  CategoryCard(this.document);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SubCategoryWidget(document['name']);
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 190, 188, 188),
              border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
              borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            height: 140,
            width: 140,
            child: Card(
              color: Color.fromARGB(255, 252, 184, 210),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 90,
                        width: double.infinity,
                        child: Image.network(document['image']),
                      ),
                      FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            document['name'],
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
