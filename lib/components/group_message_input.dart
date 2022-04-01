import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_three_broomsticks/support/support.dart';

class GroupMessageInput extends StatefulWidget {
  GroupMessageInput({Key? key, required this.isCommonRoom}) : super(key: key);
  bool isCommonRoom;

  @override
  _GroupMessageInputState createState() => _GroupMessageInputState();
}

class _GroupMessageInputState extends State<GroupMessageInput> {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final messageFieldController = TextEditingController();
    final fstore = FirebaseFirestore.instance;
    final dbRef =
        FirebaseDatabase.instance.ref().child('rooms').child('cafeteria');
    String msg = "";

    void sendMessage() async {
      if (msg.isNotEmpty) {
        await dbRef.push().set({
          "message": msg,
          "timestamp": DateTime.now().toString(),
          "uid": box.read('uid'),
          "nickname": box.read('nickname'),
          "displayImage": box.read('imageUrl'),
          "isMessageDeleted": false,
        });

        msg = "";
      } else {
        Support.toast("Please type something to send!");
      }
    }

    void sendMessageToCommonRoom() async {
      if (msg.isNotEmpty) {
        await fstore
            .collection(
                "${box.read('house').toString().toLowerCase()}CommonRoom")
            .doc()
            .set({
          "message": msg,
          "timestamp": Timestamp.now(),
          "uid": box.read('uid'),
          "nickname": box.read('nickname'),
          "displayImage": box.read('imageUrl'),
          "isMessageDeleted": false,
        });

        msg = "";

        // await fstore
        //     .collection("group_head")
        //     .doc("group_info")
        //     .update({"timestamp": Timestamp.now()});
      } else {
        Support.toast("Please type something to send!");
      }
    }

    // Future<void> checkBlockedUser() async {
    //   var data = await FirebaseFirestore.instance
    //       .collection("group_head")
    //       .doc("blocked_users")
    //       .get();
    //   var isAdmin =
    //       await FirebaseFirestore.instance.collection("users").doc(kUID).get();
    //
    //   if (data.data()["temp"].contains(kUID) ||
    //       data.data()["permanent"].contains(kUID) ||
    //       data.data()["chatDisabled"] == true ||
    //       data.data()["adminOnly"] == true) {
    //     Support.toast(message: "You can't send any message");
    //   } else {
    //     sendMsg();
    //     messageFieldController.clear();
    //   }
    // }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 50,
              width: GetPlatform.isWeb
                  ? MediaQuery.of(context).size.width * 0.25
                  : MediaQuery.of(context).size.width * 0.7,
              color: const Color(0xffF2F2F2),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    // textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      msg = value;
                      if (widget.isCommonRoom) {
                        sendMessageToCommonRoom();
                      } else {
                        sendMessage();
                      }

                      messageFieldController.clear();
                    },
                    controller: messageFieldController,
                    onChanged: (val) {
                      msg = val;
                    },
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Send a message..',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
            radius: 22,
            backgroundColor: Theme.of(context).primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send),
              iconSize: 22,
              color: Colors.white,
              onPressed: () {
                // checkBlockedUser();
                if (widget.isCommonRoom) {
                  sendMessageToCommonRoom();
                } else {
                  sendMessage();
                }

                messageFieldController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
