import 'dart:io';

import 'package:admin_panel_pfe/widgets/vendor/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPicCard extends StatefulWidget {
  @override
  State<ShopPicCard> createState() => _ShopPicCardState();
}

class _ShopPicCardState extends State<ShopPicCard> {
  File? _imagee;

  @override
  Widget build(BuildContext context) {
    final _imageData = Provider.of<ImageProviderVendor>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _imageData.getImage().then((image) {
            setState(() {
              _imagee = image;
            });
            if (image != null) {
              _imageData.isPickAvail = true;
            }
          });
        },
        child: SizedBox(
          height: 150,
          width: 150,
          child: Card(
            child: _imagee == null
                ? Center(
                    child: Text(
                    "Add Shop Image",
                    style: TextStyle(color: Colors.grey),
                  ))
                : Image.file(
                    _imagee!,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ),
    );
  }
}
