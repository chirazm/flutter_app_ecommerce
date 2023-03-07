import 'package:marque_blanche_seller/const/const.dart';

import 'text_style.dart';
import 'package:intl/intl.dart' as intl;

AppBar appbarWidget(title) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: white,
    title: boldText(text: title, color: Colors.black, size: 18.0),
    actions: [
      Center(
        child: normalText(
            text: intl.DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now()),
            color: purpleColor),
      ),
      10.widthBox,
    ],
  );
}
