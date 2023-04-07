import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  static const String routeName = "\ProductScreen";
  Widget rowHeader(String text, int flex) {
    return Expanded(
        child: Container(
      child: Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: Colors.yellow.shade900,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Products',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Row(
            children: [
              rowHeader('Image', 1),
              rowHeader('Name', 3),
              rowHeader('Price', 2),
              rowHeader('Quantity', 2),
              rowHeader('Action', 1),
              rowHeader('View more', 1)
            ],
          ),
        ],
      ),
    );
  }
}
