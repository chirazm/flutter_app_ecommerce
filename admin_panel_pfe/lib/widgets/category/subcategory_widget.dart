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
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 300,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            future: _services.category.doc(widget.categoryName).get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Main category :'),
                              Text(
                                widget.categoryName,
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
                    Container(
                      //subcategory list
                      child: Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(data['subCat'][index]['name']),
                            );
                          },
                          itemCount: data['subCat'] == null
                              ? 0
                              : data['subCat'].length,
                        ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Add new SubCategory",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                                      hintText:
                                                          'Sub Category Name',
                                                      border:
                                                          OutlineInputBorder(),
                                                      focusedBorder:
                                                          OutlineInputBorder(),
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 10)),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (_subcategoryTextController
                                                    .text.isEmpty) {
                                                  _services.showMyDialog(
                                                      context: context,
                                                      title:
                                                          'Add New SubCategory',
                                                      message:
                                                          'Need to Give SubaCategory Name');
                                                }
                                                DocumentReference doc =
                                                    _services.category.doc(
                                                        widget.categoryName);
                                                doc.update({
                                                  'subCat':
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'name':
                                                          _subcategoryTextController
                                                              .text
                                                    }
                                                  ]),
                                                });
                                                _subcategoryTextController
                                                    .clear();
                                              },
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
