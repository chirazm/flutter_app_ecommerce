class Coupon {
  final String id;
  final String title;
  final String details;
  final bool active;
  final DateTime expiry;
  final double discountRate;

  Coupon({
    required this.id,
    required this.title,
    required this.details,
    required this.active,
    required this.expiry,
    required this.discountRate,
  });
}
