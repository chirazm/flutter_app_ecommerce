import 'package:admin_panel_pfe/consts/colors.dart';
import 'package:admin_panel_pfe/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubCategoryWidget extends StatefulWidget {
  final String categoryName;

  SubCategoryWidget(this.categoryName);

  @override
  State<SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  FirebaseServices _services = FirebaseServices();
  var _subcategoryTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subcategoryTextController = TextEditingController();
  }

  @override
  void dispose() {
    _subcategoryTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 300,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<DocumentSnapshot>(
            future: _services.category.doc(widget.categoryName).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              Map<String, dynamic>? data =
                  snapshot.data?.data() as Map<String, dynamic>?;

              String categoryName = widget.categoryName;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Main category : '),
                            Text(
                              categoryName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 3,
                        ),
                      ],
                    ),
                  ),
                  if (data == null || data['subCat'] == null)
                    Expanded(
                      child: Center(
                        child: Text('No SubCategories Added'),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(data['subCat'][index]['name']),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: buttonColor,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Deletion'),
                                      content: Text(
                                          'Are you sure you want to delete this subcategory?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            DocumentReference doc = _services
                                                .category
                                                .doc(categoryName);
                                            doc.update({
                                              'subCat': FieldValue.arrayRemove(
                                                  [data['subCat'][index]])
                                            }).then((value) {
                                              doc.get().then((snapshot) {
                                                setState(() {
                                                  _subcategoryTextController
                                                      .clear();
                                                });
                                              });
                                            });
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                        itemCount: data['subCat'].length,
                      ),
                    ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Divider(
                                thickness: 4,
                              ),
                              Container(
                                color: Colors.grey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Add new SubCategory",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 30,
                                            child: TextField(
                                              controller:
                                                  _subcategoryTextController,
                                              decoration: InputDecoration(
                                                hintText: 'Sub Category Name',
                                                border: OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(),
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding:
                                                    EdgeInsets.only(left: 10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (_subcategoryTextController
                                                .text.isEmpty) {
                                              _services.showMyDialog(
                                                context: context,
                                                title: 'Add New SubCategory',
                                                message:
                                                    'Need to Give SubCategory Name',
                                              );
                                            } else {
                                              DocumentReference doc = _services
                                                  .category
                                                  .doc(categoryName);
                                              doc.update({
                                                'subCat':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'name':
                                                        _subcategoryTextController
                                                            .text
                                                  }
                                                ]),
                                              }).then((value) {
                                                // Fetch the updated snapshot to get the updated data
                                                doc.get().then((snapshot) {
                                                  setState(() {
                                                    _subcategoryTextController
                                                        .clear();
                                                  });
                                                });
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
