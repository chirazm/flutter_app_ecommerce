import 'package:flutter/material.dart';

class OrderController with ChangeNotifier {
  late String status;
  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }
}
