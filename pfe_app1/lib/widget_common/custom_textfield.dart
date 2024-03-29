import 'package:flutter/material.dart';
import 'package:pfe_app/consts/consts.dart';

Widget customTextField({
  String? title,
  String? hint,
  TextEditingController? controller,
  bool? isPass,
}) {
  String? errorText;
  TextInputType keyboardType = TextInputType.text;

  if (title == 'Phone' || title == 'Postal Code') {
    keyboardType = TextInputType.number;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(redColor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        obscureText: isPass ?? false,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: redColor),
          ),
        ),
      ),
      5.heightBox,
    ],
  );
}
