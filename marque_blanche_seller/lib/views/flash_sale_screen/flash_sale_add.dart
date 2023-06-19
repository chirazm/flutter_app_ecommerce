import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:intl/intl.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

class FlashSaleAddProduct extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImageURL;

  const FlashSaleAddProduct({
    required this.productId,
    required this.productName,
    required this.productImageURL,
    Key? key,
  }) : super(key: key);

  @override
  _FlashSaleAddProductState createState() => _FlashSaleAddProductState();
}

class _FlashSaleAddProductState extends State<FlashSaleAddProduct> {
  DateTime? selectedEndDate;
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFlashSaleData();
  }

  @override
  void dispose() {
    _endDateController.dispose();
    _discountPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkGrey,
            )),
        title: boldText(
          text: "Flash Sale Product",
          color: fontGrey,
          size: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(widget.productImageURL),
            const SizedBox(height: 16),
            TextFormField(
              controller: _endDateController,
              decoration: InputDecoration(
                labelText: 'End Date',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectEndDate,
                ),
              ),
              onTap: _selectEndDate,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _discountPriceController,
              decoration: const InputDecoration(
                labelText: 'Discount Price',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: purpleColor),
              onPressed: _saveFlashSaleData,
              child: const Text('Save Flash Sale Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchFlashSaleData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        Timestamp endDateTimestamp = data['endDate'] as Timestamp;
        String discountPrice = data['discountedPrice'] as String;

        setState(() {
          selectedEndDate = endDateTimestamp.toDate();
          _endDateController.text =
              DateFormat('dd/MM/yyyy HH:mm').format(selectedEndDate!);
          _discountPriceController.text = discountPrice;
        });
      }
    } catch (error) {
      print('Failed to fetch flash sale data: $error');
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedEndDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _endDateController.text =
              DateFormat('dd/MM/yyyy HH:mm').format(selectedEndDate!);
        });
      }
    }
  }

  void _saveFlashSaleData() {
    if (selectedEndDate == null) {
      return;
    }

    DateTime adjustedEndDate = selectedEndDate!.toUtc().add(
          Duration(hours: DateTime.now().timeZoneOffset.inHours),
        );

    Timestamp endDateTimestamp = Timestamp.fromDate(adjustedEndDate);
    String discountPrice = _discountPriceController.text;
    String productId = widget.productId;

    FirebaseFirestore.instance.collection('products').doc(productId).update({
      'endDate': endDateTimestamp,
      'discountedPrice': discountPrice,
    }).then((value) {
      print('Flash sale Product saved successfully!');
      _showMessage('Flash sale Product saved successfully!');
    }).catchError((error) {
      print('Failed to save flash sale data: $error');
      _showMessage('Failed to save flash sale data');
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
