import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_loading/easy_loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marque_blanche_seller/const/colors.dart';
import 'package:marque_blanche_seller/const/firebase_consts.dart';
import 'package:marque_blanche_seller/controllers/products_controller.dart';
import 'package:marque_blanche_seller/views/products_screen/components/product_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProduct extends StatefulWidget {
  final String productId;
  EditProduct({required this.productId});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var controller = Get.find<ProductsController>();
  final _formKey = GlobalKey<FormState>();

  final _brandText = TextEditingController();
  final _skuText = TextEditingController();
  final _productNameText = TextEditingController();
  final _productPriceText = TextEditingController();
  final _productDescriptionText = TextEditingController();
  final _categoryText = TextEditingController();
  final _stockText = TextEditingController();
  final _subcategoryText = TextEditingController();
  //late String? dropdown = null;
  late List<String> image = [];
  late DocumentSnapshot? doc = null;
  late File _image = File('default_image.jpg');
  List<File> _images = [];
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    getProductsDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getProductsDetails();
  }

  Future<void> getProductsDetails() async {
    final DocumentSnapshot document =
        await controller.products.doc(widget.productId).get();
    if (document.exists) {
      final dynamic data = document.data();
      if (data != null && data['p_imgs'] != null) {
        setState(() {
          doc = document;
          _brandText.text = data['p_seller'];
          _skuText.text = data['p_sku'];
          _productNameText.text = data['p_name'];
          _productPriceText.text = data['p_price'];
          image = List<String>.from(data['p_imgs']);
          _productDescriptionText.text = data['p_desc'];
          _categoryText.text = data['p_category'];
          _subcategoryText.text = data['p_subcategory'];
          //dropdown = data['p_category'];
          _stockText.text = data['p_quantity'];
        });
      }
    }
  }

  Future<void> addImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final newImage = File(pickedFile.path);
      setState(() {
        _images.add(newImage);
        image.add('');
      });
      final newIndex = _images.length - 1;
      await controller.uploadImages().then((url) {
        if (url != null) {
          setState(() {
            image[newIndex] = url;
          });
        }
      });
    }
  }

  Future<void> deleteImage(int index) async {
    setState(() {
      image.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Details"),
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black87,
                  child: const Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show(status: 'Saving...');
                    if (_image != null) {
                      controller.uploadImages().then((url) {
                        if (url != null) {
                          controller.updateProduct(
                              context: context,
                              productName: _productNameText.text,
                              description: _productDescriptionText.text,
                              price: _productPriceText.text,
                              category: _categoryText.text,
                              subcategory: _subcategoryText.text,
                              quantity: _stockText.text,
                              seller: _brandText.text,
                              productId: widget.productId,
                              image: image);
                          EasyLoading.dismiss();
                        } else {
                          controller.updateProduct(
                              context: context,
                              productName: _productNameText.text,
                              description: _productDescriptionText.text,
                              price: _productPriceText.text,
                              category: _categoryText.text,
                              subcategory: _subcategoryText.text,
                              quantity: _stockText.text,
                              seller: _brandText.text,
                              productId: widget.productId,
                              image: image);
                          EasyLoading.dismiss();
                        }
                      });
                    }
                  }
                },
                child: Container(
                  color: Colors.pinkAccent,
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: doc == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                height: 30,
                                child: TextFormField(
                                  controller: _brandText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    hintText: 'Brand',
                                    hintStyle: const TextStyle(
                                      color: fontGrey,
                                    ),
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: purpleColor.withOpacity(.1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none),
                              controller: _productNameText,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    suffixText: 'TND',
                                  ),
                                  controller: _productPriceText,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              const Text(
                                "All inclusive of Taxes",
                                style: TextStyle(color: fontGrey, fontSize: 12),
                              ),
                            ],
                          ),
                          VxSwiper.builder(
                            autoPlay: true,
                            height: 310,
                            itemCount: image.length,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1.0,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  controller.uploadImages().then((image) {
                                    setState(() {
                                      _image = image;
                                    });
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Image.network(
                                    image[index],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          Row(
                            children: [
                              const Text(
                                'Stock : ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  controller: _stockText,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          const Text(
                            'About this product',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              maxLines: null,
                              controller: _productDescriptionText,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(color: fontGrey),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Text(
                            'Category',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          productDropdown("Category", controller.categoryList,
                              controller.categoryvalue, controller),
                          10.heightBox,
                          const Text(
                            'SubCategory',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          productDropdown(
                              "Subcategory",
                              controller.subcategoryList,
                              controller.subcategoryvalue,
                              controller),
                          SizedBox(
                            height: 70,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
