class Product {
  final String id;
  final String? name;
  final String price;
  final String imageURL;
  final DateTime? endDate;
  final String desc;
  Product({
    required this.id,
    this.name,
    required this.price,
    required this.desc,
    required this.imageURL,
    this.endDate,
  });
}
