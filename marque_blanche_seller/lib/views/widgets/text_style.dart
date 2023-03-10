import 'package:marque_blanche_seller/const/const.dart';

Widget normalText({text, color = Colors.white, size = 14.0}) {
  return "$text".text.color(color).size(size).make();
}

Widget boldText(
    {text, color = Colors.white, size = 16.0, FontWeight = FontWeight.normal}) {
  return "$text".text.color(color).size(size).fontWeight(FontWeight).make();
}

Widget boldText1(
    {text, color = Colors.white, size = 16.0, FontWeight = FontWeight.bold}) {
  return "$text".text.color(color).size(size).fontWeight(FontWeight).make();
}
