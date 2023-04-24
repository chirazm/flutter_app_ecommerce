import 'package:flutter/material.dart';
import 'package:marque_blanche_seller/views/coupon_screen/add_edit_coupon_screen.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AddEditCoupon(),
    );
  }
}
