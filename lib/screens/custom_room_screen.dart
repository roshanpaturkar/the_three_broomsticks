import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/components/group_message_input.dart';
import 'package:the_three_broomsticks/components/message_tiles.dart';
import 'package:the_three_broomsticks/screens/common_room_info_screen.dart';
import 'package:the_three_broomsticks/support/chat_room_support.dart';
import 'package:the_three_broomsticks/support/support.dart';

class CustomRoomScreen extends StatefulWidget {
  const CustomRoomScreen({Key? key}) : super(key: key);

  @override
  State<CustomRoomScreen> createState() => _CustomRoomScreenState();
}

class _CustomRoomScreenState extends State<CustomRoomScreen> {
  final dbRef = FirebaseDatabase.instance.ref();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    ChatRoomSupport support = ChatRoomSupport();
    support.updateLastSeen(Get.arguments[1], false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ChatRoomSupport support = ChatRoomSupport();
        support.updateLastSeen(Get.arguments[1], false);
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0181A20),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0181A20),
          title: GestureDetector(
            onTap: () {
              if (Get.arguments[0]['createdBy']['uid'] == box.read('uid')) {
                Get.to(const CommonRoomInfoScreen(), arguments: Get.arguments);
              } else {
                Support.toast('Your not the admin of the room!');
              }
            },
            child: SizedBox(
              width: 380,
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(Get.arguments[0]['icon']),
                    backgroundImage: const AssetImage('images/cafeteria.png'),
                    radius: 16,
                    backgroundColor: const Color(0xFF262A34),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    '${Get.arguments[0]['name']} !',
                    style: GoogleFonts.dancingScript(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
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
                    child: StreamBuilder(
                      stream: dbRef
                          .child('rooms')
                          .child(Get.arguments[0]['roomPath'])
                          .onValue,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          final data = snapshot.data!.snapshot.value;

                          if (data != null) {
                            List messageDataKeys = data.keys.toList()..sort();
                            List messageKeys =
                                messageDataKeys.reversed.toList();

                            return ListView.builder(
                                reverse: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return MessageTiles(
                                    messages: data[messageKeys[index]],
                                    isCommonRoom: false,
                                  );
                                });
                          } else {
                            return Center(
                              child: Text(
                                'Message not found!',
                                style: GoogleFonts.patrickHandSc(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                ),
                              ),
                            );
                          }
                        }
                        return const Center(
                          child: Text('There is something wrong!'),
                        );
                      },
                    ),
                  ),
                ),
                GroupMessageInput(
                  isCommonRoom: false,
                  dbPath: Get.arguments[0]['roomPath'],
                  headId: Get.arguments[1]!,
                  roomInfo: Get.arguments[0],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
