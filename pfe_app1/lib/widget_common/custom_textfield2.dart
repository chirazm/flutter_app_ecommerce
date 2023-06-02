import 'package:flutter/material.dart';
import 'package:pfe_app/consts/consts.dart';

Widget customTextField2({
  String? title,
  String? hint,
  TextEditingController? controller,
  bool? isPass,
  required String? Function(dynamic value) validator,
}) {
  String? errorText;
  TextInputType keyboardType = TextInputType.text;

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
          errorText: errorText,
        ),
      ),
      5.heightBox,
    ],
  );
}
