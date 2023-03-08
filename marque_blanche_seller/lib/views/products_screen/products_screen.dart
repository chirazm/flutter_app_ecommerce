import 'package:get/get.dart';
import 'package:marque_blanche_seller/views/products_screen/add_product.dart';
import 'package:marque_blanche_seller/views/products_screen/product_details.dart';
import 'package:marque_blanche_seller/views/widgets/appbar_widget.dart';

import '../../const/const.dart';
import '../widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddProduct());
        },
        backgroundColor: purpleColor,
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget(products),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: List.generate(
                20,
                (index) => ListTile(
                      onTap: () {
                        Get.to(() => const ProductDetails());
                      },
                      leading: Image.asset(
                        imgProduct,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      title: boldText(text: "Product title", color: fontGrey),
                      subtitle: Row(
                        children: [
                          normalText(text: "40.0 TND", color: darkGrey),
                          10.widthBox,
                          boldText(text: "Featured", color: green)
                        ],
                      ),
                      trailing: VxPopupMenu(
                        arrowSize: 0.0,
                        menuBuilder: () => Column(
                            children: List.generate(
                                popupMenuTitles.length,
                                (index) => Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Icon(popupMenuIcons[index]),
                                          10.widthBox,
                                          normalText(
                                              text: popupMenuTitles[index],
                                              color: darkGrey)
                                        ],
                                      ).onTap(() {}),
                                    ))).box.white.width(200).make(),
                        clickType: VxClickType.singleClick,
                        child: const Icon(Icons.more_vert_rounded),
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
