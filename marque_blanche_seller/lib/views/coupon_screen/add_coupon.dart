import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marque_blanche_seller/const/colors.dart';
import 'package:marque_blanche_seller/controllers/coupon_controller.dart';
import 'package:marque_blanche_seller/views/widgets/loading_indicator.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class AddCoupon extends StatefulWidget {
  const AddCoupon({super.key});

  @override
  State<AddCoupon> createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  var dateText = TextEditingController();
  var titleText = TextEditingController();
  var detailsText = TextEditingController();
  var discountRate = TextEditingController();
  bool _active = false;

  _selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        String formattedText = DateFormat('yyyy-MM-dd').format(_selectedDate);
        _selectedDate = picked;
        dateText.text = formattedText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CouponController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add / Edit Coupon ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 30.0, left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                TextFormField(
                  controller: titleText,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Coupon title';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 20),
                      labelText: 'Coupon title',
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: discountRate,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Discount %';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 20),
                      labelText: 'Discount %',
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: dateText,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Apply Expiry Date';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 20),
                      labelText: 'Expiry Date',
                      labelStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: const Icon(Icons.date_range_outlined),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: detailsText,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Coupon details';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 20),
                    labelText: 'Coupon Details',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SwitchListTile(
                    activeColor: Colors.green,
                    contentPadding: const EdgeInsets.only(top: 20),
                    title: const Text('Activate Coupon'),
                    value: _active,
                    onChanged: (bool newValue) {
                      setState(() {
                        _active = !_active;
                      });
                    }),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            //minimumSize: const Size(100, 40),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ProgressDialog pd =
                                  ProgressDialog(context: context);
                              pd.show(
                                max: 100,
                                msg: 'Waiting...',
                              );
                              controller
                                  .saveCoupon(
                                title: titleText.text.toUpperCase(),
                                details: detailsText.text,
                                discountRate: int.parse(discountRate.text),
                                expiry: _selectedDate,
                                active: _active,
                              )
                                  .then((value) {
                                setState(() {
                                  titleText.clear();
                                  discountRate.clear();
                                  detailsText.clear();

                                  _active = false;
                                });
                                pd.close();
                              });
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
