import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/controllers/home_controller.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var chats = firestore.collection(chatCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().usename;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();
  dynamic chatDocId;
  var isloading = false.obs;
  getChatId() async {
    isloading(true);
    await chats
        .where('users', isEqualTo: {friendId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
          } else {
            chats.add({
              'created_on': null,
              'last_msg': '',
              'users': {friendId: null, currentId: null},
              'toId ': '',
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

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId ': friendId,
        'fromId': currentId,
      });
      chats.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
