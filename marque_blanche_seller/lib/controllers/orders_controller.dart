import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';

class OrdersController extends GetxController {
  var orders = [];
  var confirmed = false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;
  var searchController = TextEditingController();

  getOrders(data) {
    orders.clear();
    for (var item in data['orders']) {
      if (item['vendor_id'] == currentUser!.uid) {
        orders.add(item);
      }
    }
  }

  changeStatus({title, status, docID}) async {
    var store = firestore.collection(ordersCollection).doc(docID);
    await store.set({title: status}, SetOptions(merge: true));
  }

  Future<void> deleteOrder(dynamic orderData) async {
    try {
      final ordersCollection = FirebaseFirestore.instance.collection('orders');

      final querySnapshot = await ordersCollection
          .where('order_date', isEqualTo: orderData['order_date'])
          .where('order_by', isEqualTo: orderData['order_by'])
          .where('order_by_name', isEqualTo: orderData['order_by_name'])
          .where('order_by_email', isEqualTo: orderData['order_by_email'])
          .where('order_by_address', isEqualTo: orderData['order_by_address'])
          .where('order_by_state', isEqualTo: orderData['order_by_state'])
          .where('order_by_city', isEqualTo: orderData['order_by_city'])
          .where('order_by_phone', isEqualTo: orderData['order_by_phone'])
          .where('order_by_postalcode',
              isEqualTo: orderData['order_by_postalcode'])
          .where('shipping_method', isEqualTo: orderData['shipping_method'])
          .where('payment_method', isEqualTo: orderData['payment_method'])
          .where('order_placed', isEqualTo: orderData['order_placed'])
          .where('order_confirmed', isEqualTo: orderData['order_confirmed'])
          .where('order_delivered', isEqualTo: orderData['order_delivered'])
          .where('order_on_delivery', isEqualTo: orderData['order_on_delivery'])
          .where('total_amount', isEqualTo: orderData['total_amount'])
          .get();

      for (final doc in querySnapshot.docs) {
        await ordersCollection.doc(doc.id).delete();
      }

      orders.removeWhere((order) =>
          order['order_date'] == orderData['order_date'] &&
          order['order_by'] == orderData['order_by'] &&
          order['order_by_name'] == orderData['order_by_name'] &&
          order['order_by_email'] == orderData['order_by_email'] &&
          order['order_by_address'] == orderData['order_by_address'] &&
          order['order_by_state'] == orderData['order_by_state'] &&
          order['order_by_city'] == orderData['order_by_city'] &&
          order['order_by_phone'] == orderData['order_by_phone'] &&
          order['order_by_postalcode'] == orderData['order_by_postalcode'] &&
          order['shipping_method'] == orderData['shipping_method'] &&
          order['payment_method'] == orderData['payment_method'] &&
          order['order_placed'] == orderData['order_placed'] &&
          order['order_confirmed'] == orderData['order_confirmed'] &&
          order['order_delivered'] == orderData['order_delivered'] &&
          order['order_on_delivery'] == orderData['order_on_delivery'] &&
          order['total_amount'] == orderData['total_amount']);
      Navigator.of(Get.context!).pop();

      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("The order has been deleted."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.back();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
