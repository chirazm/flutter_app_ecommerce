import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/const/const.dart';
import 'package:marque_blanche_seller/services/store_services.dart';
import 'package:marque_blanche_seller/views/messages_screen/chat_screen.dart';
import 'package:marque_blanche_seller/views/widgets/loading_indicator.dart';
import 'package:marque_blanche_seller/views/widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: darkGrey,
          ),
        ),
        title: "My Messages".text.color(fontGrey).make(),
      ),
      body: StreamBuilder(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else if (snapshot.data!.docs.isEmpty) {
            return "No messages yet !".text.color(purpleColor).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(data.length, (index) {
                    var t = data[index]['created_on'] == null
                        ? DateTime.now()
                        : data[index]['created_on'].toDate();
                    var time = intl.DateFormat("h:mma").format(t);

                    return ListTile(
                      onTap: () {
                        Get.to(
                          () => const ChatScreen(),
                          arguments: [
                            data[index]['sender_name'],
                            data[index]['fromId'],
                          ],
                        );
                      },
                      leading: const CircleAvatar(
                        backgroundColor: purpleColor,
                        child: Icon(
                          Icons.person,
                          color: white,
                        ),
                      ),
                      title: boldText(
                        text: "${data[index]['sender_name']}",
                        color: fontGrey,
                      ),
                      subtitle: normalText(
                        text: "${data[index]['last_msg']}",
                        color: darkGrey,
                      ),
                      trailing: normalText(
                        text: time,
                        color: darkGrey,
                      ),
                    );
                  }),
                ),
              ),
            );
          }
        },
      ),
      //
    );
  }
}
