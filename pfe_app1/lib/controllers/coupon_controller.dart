import 'package:get/get.dart';
import 'package:pfe_app/views/cart_screen/coupn.dart';

class CouponController extends GetxController {
  RxList<Coupon> coupons = <Coupon>[].obs;
  Rx<Coupon?> activeCoupon = Rx<Coupon?>(null);

  void getCoupons() {

    coupons.value = [
      Coupon(
          id: '1',
          title: 'Coupon 1',
          discountRate: 10.0,
          details: "",
          active: true,
          expiry: DateTime(12, 12, 2024)),
      Coupon(
          id: '2',
          title: 'Coupon 2',
          discountRate: 15.0,
          details: "",
          active: true,
          expiry: DateTime(12, 12, 2024)),
      Coupon(
          id: '3',
          title: 'Coupon 3',
          discountRate: 20.0,
          details: "",
          active: true,
          expiry: DateTime(12, 12, 2024)),
    ];
  }

  void applyCoupon(Coupon coupon) {
    activeCoupon.value = coupon;
  }

  void removeCoupon() {
    activeCoupon.value = null;
  }

  double getDiscountedAmount(double totalPrice) {
    if (activeCoupon.value != null) {
      final discountRate = activeCoupon.value!.discountRate;
      return totalPrice * (discountRate / 100);
    }
    return 0.0;
  }
}
