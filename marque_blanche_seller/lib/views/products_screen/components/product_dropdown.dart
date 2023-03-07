import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

Widget productDropdown() {
  return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              hint: normalText(text: "Choose category", color: fontGrey),
              isExpanded: true,
              value: null,
              items: const [],
              onChanged: (value) {}))
      .box
      .padding(const EdgeInsets.symmetric(horizontal: 4))
      .roundedSM
      .make();
}
