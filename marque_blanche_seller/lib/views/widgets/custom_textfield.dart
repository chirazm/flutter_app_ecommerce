import 'package:marque_blanche_seller/views/widgets/text_style.dart';

import '../../const/const.dart';

Widget customTextField(
    {label,
    hint,
    controller,
    isDesc = false,
    required String? Function(dynamic value) validator}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: white),
    maxLines: isDesc ? 4 : 1,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter $label';
      }
     
      return null;
    },
    decoration: InputDecoration(
      isDense: true,
      label: normalText(text: label),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: white),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: lightGrey),
    ),
  );
}
