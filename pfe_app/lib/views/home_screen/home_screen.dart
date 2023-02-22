import 'package:flutter/material.dart';
import 'package:pfe_app/consts/colors.dart';
import 'package:pfe_app/consts/consts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      padding: const EdgeInsets.all(12),
      child: SafeArea(
          child: Column(
        children: [
          Container(
            color: lightGrey,
            child: TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: whiteColor,
              ),
            ),
          )
        ],
      )),
    );
  }
}
