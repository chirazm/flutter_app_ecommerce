import 'package:cloud_firestore/cloud_firestore.dart';

class Product2 {
  final String id;
  final String? name;
  final String oldPrice;
  final String flashSalePrice;
  final String imageURL;
  final Timestamp? endDate;
  final String? desc;
  final String? seller;
  final String? vendorId;
  final String quantity;
  final String? img;

  Product2({
    required this.id,
    this.desc,
    this.seller,
    this.img,
    required this.quantity,
    this.vendorId,
    this.name,
    required this.oldPrice,
    required this.flashSalePrice,
    required this.imageURL,
    this.endDate,
  });
}
