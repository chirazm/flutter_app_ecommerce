import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/controllers/home_controller.dart';

import '../const/firebase_consts.dart';

class ChatsController extends GetxController {
  late final String chatDocId;

  ChatsController({required this.chatDocId});

  @override
  void onInit() {
    super.onInit();
  }

  var chats = FirebaseFirestore.instance.collection(chatsCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();
  var isloading = false.obs;
  getChatId() async {
    isloading(true);
    await chats
        .where('users', arrayContains: friendId)
        .where('users', arrayContains: currentId)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        chatDocId = snapshot.docs.single.id;
      } else {
        chats.add({
          'created_on': null,
          'last_msg': '',
          'users': [friendId, currentId],
          'toId': '',
          'fromId': '',
          'friend_name': friendName,
          'sender_name': senderName,
        }).then((value) {
          chatDocId = value.id;
        });
      }
    });
    isloading(false);
  }

  void sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': currentId,
        'fromId': friendId,
      });
      chats.doc(chatDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
