import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pfe_app/consts/consts.dart';

Widget ourButton({
  onPress,
  color,
  textColor,
  String? title,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.all(12),
      ),
      onPressed: onPress,
      child: title!.text.color(textColor).fontFamily(bold).size(16).make());
}
