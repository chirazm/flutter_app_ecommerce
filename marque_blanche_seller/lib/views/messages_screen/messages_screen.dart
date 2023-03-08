import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/services/store_services.dart';
import 'package:marque_blanche_seller/views/messages_screen/chat_screen.dart';
import 'package:marque_blanche_seller/views/widgets/loading_indicator.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: darkGrey,
          ),
          onPressed: (() {
            Get.back();
          }),
        ),
        title: boldText(text: messages, size: 16.0, color: fontGrey),
      ),
      body: StreamBuilder(
        stream: StoreServices.getMessages(currentUser!.uid),
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
                                Get.to(() => const ChatScreen());
                              },
                              leading: const CircleAvatar(
                                backgroundColor: purpleColor,
                                child: Icon(
                                  Icons.person,
                                  color: white,
                                ),
                              ),
                              title: boldText(
                                  text: "${data[index]['sender_name']}"),
                              subtitle: normalText(
                                  text: "last message...", color: darkGrey),
                              trailing:
                                  normalText(text: "10:45PM", color: darkGrey),
                            )),
                  )),
            );
          }
        },
      ),
    );
  }
}
