import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/controllers/products_controller.dart';
import 'package:marque_blanche_seller/services/store_services.dart';
import 'package:marque_blanche_seller/views/products_screen/add_product.dart';
import 'package:marque_blanche_seller/views/products_screen/edit_product.dart';
import 'package:marque_blanche_seller/views/products_screen/product_details.dart';
import 'package:marque_blanche_seller/views/widgets/appbar_widget.dart';
import 'package:marque_blanche_seller/views/widgets/loading_indicator.dart';

import '../../const/const.dart';
import '../widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => const AddProduct());
        },
        backgroundColor: purpleColor,
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget(products),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                      data.length,
                      (index) => ListTile(
                            onTap: () {
                              Get.to(() => ProductDetails(
                                    data: data[index],
                                  ));
                            },
                            leading: Image.network(
                              data[index]['p_imgs'][0],
                              width: 100,
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                            title: boldText(
                              text: "${data[index]['p_name']}",
                              color: darkGrey,
                              FontWeight: FontWeight.bold,
                              size: 18.0,
                            ),
                            subtitle: Row(
                              children: [
                                Row(
                                  children: [
                                    boldText(
                                      text: "Qty : ",
                                      color: red,
                                      FontWeight: FontWeight.bold,
                                    ),
                                    boldText(
                                      text: "${data[index]['p_quantity']}",
                                      color: darkGrey,
                                      FontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                50.widthBox,
                                boldText(
                                  text: data[index]['is_featured'] == true
                                      ? "Featured"
                                      : '',
                                  color: green,
                                )
                              ],
                            ),
                            trailing: VxPopupMenu(
                              arrowSize: 0.0,
                              menuBuilder: () => Column(
                                  children: List.generate(
                                      popupMenuTitles.length,
                                      (i) => Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  popupMenuIcons[i],
                                                  color:
                                                      data[index]['featured_id'] ==
                                                                  currentUser!
                                                                      .uid &&
                                                              i == 0
                                                          ? green
                                                          : darkGrey,
                                                ),
                                                10.widthBox,
                                                normalText(
                                                    text: data[index][
                                                                    'featured_id'] ==
                                                                currentUser!
                                                                    .uid &&
                                                            i == 0
                                                        ? 'Remove feature'
                                                        : popupMenuTitles[i],
                                                    color: darkGrey)
                                              ],
                                            ).onTap(() {
                                              switch (i) {
                                                case 0:
                                                  if (data[index]
                                                          ['is_featured'] ==
                                                      true) {
                                                    controller.removeFeatured(
                                                        data[index].id);
                                                    VxToast.show(context,
                                                        msg: "Removed");
                                                  } else {
                                                    controller.addFeatured(
                                                        data[index].id);
                                                    VxToast.show(context,
                                                        msg: "Added");
                                                  }
                                                  break;
                                                case 1:
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProduct(
                                                              productId:
                                                                  data[index]
                                                                      .id),
                                                    ),
                                                  );
                                                  break;
                                                case 2:
                                                  controller.removeProduct(
                                                      data[index].id);
                                                  VxToast.show(context,
                                                      msg: "Product removed");
                                                  break;
                                                default:
                                              }
                                            }),
                                          ))).box.white.width(200).make(),
                              clickType: VxClickType.singleClick,
                              child: const Icon(Icons.more_vert_rounded),
                            ),
                          )),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
