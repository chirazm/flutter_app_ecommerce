class Product {
  final String id;
  final String? name;
  final String price;
  final String imageURL;
  final DateTime? endDate;
  final String? desc;
  final String? seller;
  final String? vendorId;
  final String quantity;
  final String? img;

  Product({
    required this.id,
    this.desc,
    this.seller,
    this.img,
    required this.quantity,
    this.vendorId,
    this.name,
    required this.price,
    required this.imageURL,
    this.endDate,
  });
}