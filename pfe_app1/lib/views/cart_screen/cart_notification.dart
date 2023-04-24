import 'package:flutter/material.dart';
import 'package:pfe_app/consts/colors.dart';

class CartNotification extends StatelessWidget {
  const CartNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      color: redColor,
      child: Row(
        children: [Text('3 | items')],
      ),
    );
  }
}
