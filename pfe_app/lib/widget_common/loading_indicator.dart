import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfe_app/consts/colors.dart';

Widget loadingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(redColor),
  );
}
