import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pfe_app/consts/colors.dart';

class CouponWidget extends StatefulWidget {
  const CouponWidget({super.key});

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  Color color = Colors.grey;
  bool _enable = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        hintText: 'Enter Voucher Code',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      onChanged: (String value) {
                        if (value.length < 3) {
                          setState(() {
                            color = Colors.grey;
                            _enable = false;
                          });
                          if (value.isNotEmpty) {
                            setState(() {
                              color = Colors.green;
                              _enable = true;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
                AbsorbPointer(
                  absorbing: _enable ? false : true,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: color,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Apply',
                      style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DottedBorder(
              color: Colors.black,
              strokeWidth: 2,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: redColor.withOpacity(.3),
                      ),
                      width: MediaQuery.of(context).size.width - 80,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text("JAM001"),
                          ),
                          Divider(
                            color: Colors.grey.shade800,
                          ),
                          const Text('New Year Special Discount'),
                          const Text("20% discount on total purchase"),
                          const SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        right: -5.0,
                        top: -10,
                        child: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.clear))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
