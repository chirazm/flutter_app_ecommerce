class Seller {
  final String name;
  final String image;
  int numberOfProducts;
  final String vendorId; 

  Seller( {required this.vendorId,required this.name, required this.image, this.numberOfProducts = 0});
}
