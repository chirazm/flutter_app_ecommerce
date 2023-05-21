// // ignore_for_file: prefer_typing_uninitialized_variables

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pfe_app/consts/colors.dart';
// import 'package:pfe_app/controllers/coupon_controller.dart';

// class CouponWidget extends StatefulWidget {
//   final couponVendor;
//   CouponWidget(this.couponVendor);

//   @override
//   State<CouponWidget> createState() => _CouponWidgetState();
// }

// class _CouponWidgetState extends State<CouponWidget> {
//   Color color = Colors.grey;
//   bool _enable = false;
//   bool _visible = false;
//   var couponText = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.find<CouponController>();

//     return Container(
//       color: whiteColor,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 38,
//                     child: TextField(
//                       controller: couponText,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         filled: true,
//                         fillColor: Colors.grey.shade300,
//                         hintText: 'Enter Voucher Code',
//                         hintStyle: const TextStyle(color: Colors.grey),
//                       ),
//                       onChanged: (String value) {
//                         if (value.length < 3) {
//                           setState(() {
//                             color = Colors.grey;
//                             _enable = false;
//                           });
//                           if (value.isNotEmpty) {
//                             setState(() {
//                               color = Colors.green;
//                               _enable = true;
//                             });
//                           }
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 AbsorbPointer(
//                   absorbing: _enable ? false : true,
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(
//                         color: color,
//                       ),
//                     ),
//                     onPressed: () {
//                       controller
//                           .getCouponDetails(
//                               couponText.text, widget.couponVendor)
//                           .then((value) {
//                         if (value.data() == null) {
//                           setState(() {
//                             controller.discountRate = 0;
//                             _visible = false;
//                           });
//                           showDialog(couponText.text, 'Not Valid');
//                           return;
//                         }
//                         if (controller.expired == false) {
//                           setState(() {
//                             _visible = true;
//                           });
//                           return;
//                         }
//                         if (controller.expired == true) {
//                           setState(() {
//                             controller.discountRate = 0;
//                             _visible = false;
//                           });
//                           showDialog(couponText.text, 'Expired');
//                           return;
//                         }
//                       });
//                     },
//                     child: Text(
//                       'Apply',
//                       style: TextStyle(
//                           color: color,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Visibility(
//             visible: _visible,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: DottedBorder(
//                 color: Colors.black,
//                 strokeWidth: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           color: redColor.withOpacity(.3),
//                         ),
//                         width: MediaQuery.of(context).size.width - 80,
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(top: 4),
//                               child: Text((controller.document.data()
//                                   as dynamic)['title']),
//                             ),
//                             Divider(
//                               color: Colors.grey.shade800,
//                             ),
//                             Text((controller.document!.data()
//                                 as dynamic)['title']),
//                             Text(
//                                 "${(controller.document!.data() as dynamic)['title']}% discount on total purchase"),
//                             const SizedBox(
//                               height: 6,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                           right: -5.0,
//                           top: -10,
//                           child: IconButton(
//                               onPressed: () {}, icon: const Icon(Icons.clear))),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   showDialog(code, validity) {
//     showCupertinoDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CupertinoAlertDialog(
//             title: Text('APPLY COUPON'),
//             content: Text(
//                 'This discount coupon $code you have entered is $validity. Please try with another code'),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'OK',
//                     style: TextStyle(
//                         color: Colors.amber, fontWeight: FontWeight.bold),
//                   ))
//             ],
//           );
//         });
//   }
// }
