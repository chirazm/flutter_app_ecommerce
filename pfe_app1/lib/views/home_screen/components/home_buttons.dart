import 'package:flutter/cupertino.dart';
import 'package:pfe_app/consts/consts.dart';

Widget HomeButtons({
  required double width,
  required double height,
  required String icon,
  required String title,
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          width: 35,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: darkFontGrey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    )
        .box
        .rounded
        .white
        .color(lightGolden)
        .border(color: redColor)
        .size(width, height)
        .make(),
  );
}
