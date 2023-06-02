class Product {
  String id;
  String name;
  String price;
  String imageURL;
  DateTime? endDate;
  String? discountPrice;
  String quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageURL,
    this.endDate,
    this.discountPrice,
    required this.quantity,
  });
}
