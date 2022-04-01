import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/components/group_message_input.dart';
import 'package:the_three_broomsticks/components/message_tiles.dart';

class CafeteriaRoomScreen extends StatefulWidget {
  const CafeteriaRoomScreen({Key? key}) : super(key: key);

  @override
  State<CafeteriaRoomScreen> createState() => _CafeteriaRoomScreenState();
}

class _CafeteriaRoomScreenState extends State<CafeteriaRoomScreen> {
  final dbRef =
      FirebaseDatabase.instance.ref().child('rooms').child('cafeteria');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                backgroundImage: const AssetImage('images/cafeteria.png'),
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
                  child: StreamBuilder(
                    stream: dbRef.onValue,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        final data = snapshot.data!.snapshot.value;

                        if (data != null) {
                          List messageDataKeys = data.keys.toList()..sort();
                          List messageKeys = messageDataKeys.reversed.toList();

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
              GroupMessageInput(isCommonRoom: false),
            ],
          ),
        ),
      ),
    );
  }
}
