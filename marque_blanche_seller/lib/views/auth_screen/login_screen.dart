import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              30.heightBox,
              normalText(text: welcome, size: 18.0),
              
            ],
          ),
        ),
      ),
    );
  }
}
