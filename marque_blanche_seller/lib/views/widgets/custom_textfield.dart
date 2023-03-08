import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

Widget customTextField({label, hint, controller, isDesc = false}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: white),
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
        isDense: true,
        label: normalText(text: label),
        /*enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: white)),*/
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: white)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: white)),
        hintText: hint,
        hintStyle: const TextStyle(color: lightGrey)),
  );
}
