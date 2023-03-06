import 'package:marque_blanche_seller/views/widgets/text_style.dart';

import '../../const/const.dart';
import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: dashboard, color: darkGrey, size: 16.0),
        actions: [
          Center(
            child: normalText(
                text:
                    intl.DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now()),
                color: purpleColor),
          ),
          10.widthBox,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(),
                Image.asset(
                  icProducts,
                  width: 40,
                  color: white,
                ),
              ],
            )
                .box
                .color(purpleColor)
                .rounded
                .size(context.screenWidth * 0.4, 80)
                .padding(const EdgeInsets.all(8))
                .make(),
          ],
        ),
      ),
    );
  }
}
