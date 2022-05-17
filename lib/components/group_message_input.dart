import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_three_broomsticks/support/notification_support.dart';
import 'package:the_three_broomsticks/support/support.dart';

class GroupMessageInput extends StatefulWidget {
  GroupMessageInput(
      {Key? key,
      required this.isCommonRoom,
      this.dbPath,
      this.headId,
      this.roomInfo})
      : super(key: key);
  bool isCommonRoom;
  String? dbPath;
  String? headId;
  var roomInfo;

  @override
  _GroupMessageInputState createState() => _GroupMessageInputState();
}

class _GroupMessageInputState extends State<GroupMessageInput> {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final NotificationSupport notification = NotificationSupport();
    final messageFieldController = TextEditingController();
    final fstore = FirebaseFirestore.instance;
    final dbRef = FirebaseDatabase.instance
        .ref()
        .child('rooms')
        .child(widget.dbPath.toString());
    String msg = "";

    var audience = widget.roomInfo['roomPath'] == 'cafeteria'
        ? widget.roomInfo['audience'].toList()
        : widget.roomInfo['users'].toList();
    audience.removeWhere((item) => item == box.read('uid'));

    void sendToCustomMessage() async {
      if (msg.isNotEmpty) {
        var data = {
          'u_ids': audience,
          'notification': {
            'title': widget.roomInfo['name'],
            'body': '${box.read('nickname')}: $msg',
            'image': widget.roomInfo['icon']
          }
        };
        notification.sendNotification(data);

        await dbRef.push().set({
          "message": msg,
          "timestamp": DateTime.now().toString(),
          "uid": box.read('uid'),
          "nickname": box.read('nickname'),
          "displayImage": box.read('imageUrl'),
          "isMessageDeleted": false,
        });

        fstore.collection('customRoomHead').doc(widget.headId).update({
          'lastMessage': Timestamp.now(),
          'lastSeen': [],
        });

        msg = "";
      } else {
        Support.toast("Please type something to send!");
      }
    }

    void sendMessageToCommonRoom() async {
      if (msg.isNotEmpty) {
        var data = {
          'u_ids': audience,
          'notification': {
            'title': widget.roomInfo['name'],
            'body': '${box.read('nickname')}: $msg',
            'image': widget.roomInfo['icon']
          }
        };
        notification.sendNotification(data);

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

        fstore
            .collection('commonRoomChatHeads')
            .doc(box.read('house').toLowerCase())
            .update({
          'lastMessage': Timestamp.now(),
          'lastSeen': [],
        }).catchError((error) {
          print(error);
        });
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
                    autofocus: true,
                    onSubmitted: (value) {
                      msg = value;
                      if (box.read('disable') < 1) {
                        if (widget.isCommonRoom) {
                          sendMessageToCommonRoom();
                        } else {
                          sendToCustomMessage();
                        }
                      } else {
                        Support.toast('You have view only access!');
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
                if (box.read('disable') < 1) {
                  if (widget.isCommonRoom) {
                    sendMessageToCommonRoom();
                  } else {
                    sendToCustomMessage();
                  }
                } else {
                  Support.toast('You have view only access!');
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
