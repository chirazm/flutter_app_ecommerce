import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_app/controllers/coupon_controller.dart';

class CouponWidgett extends StatelessWidget {
  CouponController couponController = Get.find<CouponController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const SizedBox(height: 10),
        GetBuilder<CouponController>(
          builder: (controller) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.coupons.length,
              itemBuilder: (BuildContext context, int index) {
                final coupon = controller.coupons[index];
                return GestureDetector(
                  onTap: () {
                    // Handle coupon selection and apply logic here
                    couponController.applyCoupon(coupon);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${coupon.discountRate}% off',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
