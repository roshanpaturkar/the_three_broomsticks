import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/components/group_message_input.dart';
import 'package:the_three_broomsticks/components/message_tiles.dart';
import 'package:the_three_broomsticks/support/chat_room_support.dart';

class CommonRoomScreen extends StatefulWidget {
  const CommonRoomScreen({Key? key}) : super(key: key);

  @override
  State<CommonRoomScreen> createState() => _CommonRoomScreenState();
}

class _CommonRoomScreenState extends State<CommonRoomScreen> {
  final box = GetStorage();

  final fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    ChatRoomSupport support = ChatRoomSupport();
    support.updateLastSeen(Get.arguments[3], true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ChatRoomSupport support = ChatRoomSupport();
        support.updateLastSeen(Get.arguments[3], true);
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0181A20),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0181A20),
          title: SizedBox(
            width: 380,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(Get.arguments[2]),
                  backgroundImage: AssetImage(
                      'images/${box.read('house').toLowerCase()}.png'),
                  radius: 16,
                  backgroundColor: const Color(0xFF262A34),
                ),
                Text(
                  '${Get.arguments[1]} !',
                  style: GoogleFonts.dancingScript(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: GetPlatform.isWeb
                ? MediaQuery.of(context).size.width * 0.3
                : MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: fireStore
                          .collection(Get.arguments[0])
                          .orderBy('timestamp', descending: true)
                          .where('isMessageDeleted', isEqualTo: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const SpinKitDoubleBounce(
                            color: Colors.white,
                            size: 30.0,
                          );
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot messages =
                                snapshot.data!.docs[index];

                            return MessageTiles(
                                messages: messages, isCommonRoom: true);
                          },
                        );
                      },
                    ),
                  ),
                ),
                GroupMessageInput(isCommonRoom: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
