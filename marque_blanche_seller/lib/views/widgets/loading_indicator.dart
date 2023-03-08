import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marque_blanche_seller/const/colors.dart';

Widget loadingIndicator({circleColor = purpleColor}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(circleColor),
    ),
  );
}
