class Product {
  final String id;
  final String? name;
  final String oldPrice;
  final String flashSalePrice;
  final String imageURL;
  final DateTime? endDate;
  final String? desc;
  final String? seller;
  final String? vendorId;
  final num? quantity;
  final String? img;

  Product({
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
